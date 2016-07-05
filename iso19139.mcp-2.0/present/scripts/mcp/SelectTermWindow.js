Ext.namespace("Mcp");

Ext.QuickTips.init();

/**
 * Class: Mcp.SelectTermWindow
 */

Mcp.SelectTermWindow = Ext.extend(Ext.Window, {
     /**
     * @cfg {String} name
     * Name of element to be added (mandatory).
     */
     
     /**
     * @cfg {String} ref
     * Reference of element to be added (mandatory).
     */
     
     /**
     * @cfg {String} thesaurus
     * Thesaurus used to source terms for selection (mandatory).
     */

     /**
     * @cfg {String} thesaurusUri
     * URI of thesaurus (optional).
     */
     
     //TODO: the thesaurusUri should be sourced from thesaurus if we decide to include it
     
     /**
     * @cfg {String} typeCode
     * Type of term (mandatory).
     */
     
     //TODO: ideally the typeCode should be associated with the thesaurus. Not quite sure how at the moment
     
     /**
     * @cfg {String} action
     * Action to perform on selection
     * 'add' to add selected term to referenced term
     * 'replace' to replace referenced term with selected term
     */
     
    constructor:function (cfg) {
        var defaults = {
            title: Mcp.translate('termSelectionWindowTitle'),
            width: 400,
            height: 300,
            constrain: true,
            iconCls: 'searchIcon',
            maxTerms: 40,
            action: 'add'
        };

        this.termStore = this._buildTermStore(cfg.thesaurus);
        this._maxTermsField = this._buildMaxTermsField();
        this._termFilter = this._buildTermFilter();
        this._termSelector = this._buildTermSelector();
        this._addTermButton = this._buildAddTermButton();
        this._usedInDatasetCheckbox = this._buildUsedInDatasetCheckbox();

        var config = Ext.apply({
            layout: 'fit',
            items: [{
                xtype: 'form',
                layout: 'fit',
                border: false,
                bodyStyle: 'padding: 5px; overflow: auto; overflow-x:hidden;',
                tbar: [
                    this._termFilter,
                    '->',
                    Mcp.translate('maxTerms'),
                    this._maxTermsField
                ],
                items: [this._termSelector],
                bbar: [
                    ' ',
                    this._usedInDatasetCheckbox,
                    '->',
                    this._addTermButton
                ]
            }]
        }, cfg || {}, defaults);
        
        Mcp.SelectTermWindow.superclass.constructor.call(this, config);
        
        this._termSelector.on({
            'selectionchange': this._onSelectionChange,
            scope: this
        });
        
        this._termSelector.on({
            'render': this._onTermSelectorRender,
            scope: this
        });
        
        this._termSelector.on({
            'dblclick': this._addXml,
            scope: this
        });
        
        this.on({
            'show': this._onShow,
            scope: this
        });
    },

    _onSelectionChange: function() {
         this._addTermButton.setDisabled(this._termSelector.getSelectionCount() < 1);
    },
    
    _onTermSelectorRender: function() {
        this._loadingMask = new Ext.LoadMask(this._termSelector.getEl(), {
          store: this.termStore,
          msg: translate('searching')
        });   
    },
    
    _onShow: function() {
        this._termFilter.focus(false, 10);
    },
 
    _buildTermStore: function(thesaurus) {
        var TermRecord = Ext.data.Record.create([
            {name: 'value'},
            {name: 'uri'},
            {name: 'definition'},
        ]);


        var termStore = new Ext.data.Store({
          autoLoad: true,
          proxy: new Ext.data.HttpProxy({
              url: "xml.search.keywords",
              method: 'GET'
          }),
          baseParams: {
              pNewSearch: true,
              pTypeSearch: 1,
              pThesauri: thesaurus,
              pMode: 'searchBox',
              pKeyword: '*'
          },
          reader: new Ext.data.XmlReader({
              record: 'keyword',
              id: 'uri'
          }, TermRecord),
          fields: ["value", "uri", "definition"],
          sortInfo: {
              field: "value"
          }
        });
        
        return termStore;
    },
    
    _buildTermFilter: function() {
        return new Ext.app.SearchField({
            width: 240,
            store: this.termStore,
            paramName: 'pKeyword'
        });
    },
    
    _buildMaxTermsField: function() {
        return new Ext.form.TextField({
            name: 'maxResults',
            value: 50,
            width: 40
        });
    },

    _buildTermSelector: function() {
        var tpl = new Ext.XTemplate(
            '<tpl for=".">',
                '<div  class="ux-mselect-item" ext:qtip="{definition}">{value}</div>',
            '</tpl>'
        );
        
        return new Ext.DataView({
            store: this.termStore,
            tpl: tpl,
            singleSelect: true,
            selectedClass:'ux-mselect-selected',
            itemSelector:'div.ux-mselect-item'
        });
    },
    
    _buildAddTermButton: function() {
        return new Ext.Button({
            iconCls: 'addIcon',
            disabled: true,
            text: translate('add'),
            handler: this._addXml,
            scope: this
        });
    },
    
    _buildUsedInDatasetCheckbox: function() {
        return new Ext.form.Checkbox({
            name: 'usedInDataset',
            boxLabel: Mcp.translate('usedInDataset')
        });
    },

    _addXml: function() {
        if (this._termSelector.getSelectionCount() < 1) return;
        
        var xmlFragmentTpl = new Ext.XTemplate(
            '<tpl if="action==\'add\'">',
              '<{name} xmlns:mcp="http://schemas.aodn.org.au/mcp-2.0">',
            '</tpl>',
            '<mcp:DP_Term xmlns:mcp="http://schemas.aodn.org.au/mcp-2.0" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmd="http://www.isotc211.org/2005/gmd">', 
              '<mcp:term>', 
                '<gco:CharacterString>{[values.term.get("value")]}</gco:CharacterString>', 
              '</mcp:term>', 
              '<mcp:type>', 
                '<mcp:DP_TypeCode codeList="http://schemas.aodn.org.au/mcp-2.0/schema/resources/Codelist/gmxCodelists.xml#DP_TypeCode" codeListValue="{typeCode}">{typeCode}</mcp:DP_TypeCode>', 
              '</mcp:type>', 
              '<mcp:usedInDataset>',
                '<gco:Boolean>',
                  '{usedInDataset}',
                '</gco:Boolean>',
              '</mcp:usedInDataset>',
              '<mcp:vocabularyTermURL>', 
                '<gmd:URL>{[values.term.get("uri")]}</gmd:URL>', 
              '</mcp:vocabularyTermURL>',
            '</mcp:DP_Term>', 
            '<tpl if="action==\'add\'">',
              '</{name}>', 
            '</tpl>'
		);
		
		var xmlFragment = xmlFragmentTpl.applyTemplate({
		     name: this.name,
		     thesaurusUri: this.thesaurusUri,
		     term: this._getSelectedTerm(),
		     typeCode: this.typeCode,
		     usedInDataset: this._usedInDatasetCheckbox.getValue(),
		     action: this.action
		})
		
        if (this.action == 'add') {
            id = '_X' + this.ref + '_' + this.name.replace(":","COLON");
        } else {
            id = '_X' + this.ref;
        }
        
        var input = {tag: 'input', type: 'hidden', id: id, name: id, value: this._encodeFragment(xmlFragment)};
        var dh = Ext.DomHelper;
        dh.append(Ext.get("hiddenFormElements"), input);
  
        //TODO: the following saves - we don't want that - but we do want to just update page 
        // without scrolling which this does do
        doSaveAction('metadata.update');
    },
    
    _encodeFragment: function(xmlFragment) {
        return xmlFragment.replace(/\"/g,"&quot;");
    },
    
    _getSelectedTerm: function() {
        return this._termSelector.getSelectedRecords()[0];
    },

});

Mcp.selectTerm = function(config) {
    var selectTermWindow = new Mcp.SelectTermWindow(config);
    
    selectTermWindow.show();
}
