<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:gmd="http://www.isotc211.org/2005/gmd" 
	xmlns:gts="http://www.isotc211.org/2005/gts"
	xmlns:gco="http://www.isotc211.org/2005/gco" 
	xmlns:gmx="http://www.isotc211.org/2005/gmx" 
	xmlns:srv="http://www.isotc211.org/2005/srv"
	xmlns:gml="http://www.opengis.net/gml" 
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:geonet="http://www.fao.org/geonetwork" 
	xmlns:exslt="http://exslt.org/common"
	exclude-result-prefixes="gmd gco gml gts srv xlink exslt geonet">

  <xsl:template name="iso19139.rndtBrief">
    <metadata>
			<xsl:choose>
		    <xsl:when test="geonet:info/isTemplate='s'">
		      <xsl:apply-templates mode="iso19139-subtemplate" select="."/>
		      <xsl:copy-of select="geonet:info" copy-namespaces="no"/>
		    </xsl:when>
		    <xsl:otherwise>
	
			<!-- call iso19139 brief -->
			<xsl:call-template name="iso19139-brief"/>
		    </xsl:otherwise>
		  </xsl:choose>    
    </metadata>
  </xsl:template>

	<!-- main template - the way into processing iso19139.rndt -->
	<xsl:template name="metadata-iso19139.rndt">
		<xsl:param name="schema"/>
		<xsl:param name="edit" select="false()"/>
		<xsl:param name="embedded"/>
		
        <!--<!-\- process in profile mode first -\->
		<xsl:variable name="rndtElements">
			<xsl:apply-templates mode="iso19139.rndt" select="." >
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="edit"   select="$edit"/>
				<xsl:with-param name="embedded" select="$embedded" />
			</xsl:apply-templates>
		</xsl:variable>
		
		<xsl:choose> 
			
			<!-\- If we got a match in profile mode then show it -\->
			<xsl:when test="count($rndtElements/*)>0">
				<xsl:copy-of select="$rndtElements"/>
			</xsl:when>
			
			<!-\- Otherwise process in base iso19139 mode -\->
			<xsl:otherwise>
				<xsl:apply-templates mode="iso19139" select="." >
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
					<xsl:with-param name="embedded" select="$embedded" />
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>-->
		
		<xsl:apply-templates mode="iso19139" select="." >
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
			<xsl:with-param name="embedded" select="$embedded" />
		</xsl:apply-templates>
	</xsl:template>	

	<xsl:template mode="iso19139" match="gmd:MD_Metadata|*[@gco:isoType='gmd:MD_Metadata']" priority="2">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:param name="embedded"/>
		
		<xsl:variable name="dataset" select="gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue='dataset' or normalize-space(gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue)=''"/>
		
		<!-- thumbnail -->
		<tr>
			<td valign="middle" colspan="2">
				<xsl:if test="$currTab='rndt' or $currTab='metadata' or $currTab='identification' or /root/gui/config/metadata-tab/*[name(.)=$currTab]/@flat">
					<div style="float:left;width:70%;text-align:center;">
						<!-- FIXME: template thumbnail seems not to exist 
						<xsl:variable name="md">
							<xsl:apply-templates mode="brief" select="."/>
						</xsl:variable>
						<xsl:variable name="metadata" select="exslt:node-set($md)/*[1]"/>
						<xsl:call-template name="thumbnail">
							<xsl:with-param name="metadata" select="$metadata"/>
						</xsl:call-template>
						-->
					</div>
				</xsl:if>
				<xsl:if test="/root/gui/config/editor-metadata-relation">
					<div style="float:right;">                                
						<xsl:call-template name="relatedResources">
							<xsl:with-param name="edit" select="$edit"/>
						</xsl:call-template>
					</div>
				</xsl:if>
			</td>
		</tr>
		
		<xsl:choose>
			
			<!-- metadata tab -->
			<xsl:when test="$currTab='metadata'">
				<xsl:call-template name="iso19139Metadata">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit" select="$edit"/>
				</xsl:call-template>
			</xsl:when>
			
			<!-- identification tab -->
			<xsl:when test="$currTab='identification'">
				<xsl:apply-templates mode="elementEP" select="gmd:identificationInfo|geonet:child[string(@name)='identificationInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit" select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<!-- maintenance tab -->
			<xsl:when test="$currTab='maintenance'">
				<xsl:apply-templates mode="elementEP" select="gmd:metadataMaintenance|geonet:child[string(@name)='metadataMaintenance']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit" select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<!-- constraints tab -->
			<xsl:when test="$currTab='constraints'">
				<xsl:apply-templates mode="elementEP" select="gmd:metadataConstraints|geonet:child[string(@name)='metadataConstraints']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit" select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<!-- spatial tab -->
			<xsl:when test="$currTab='spatial'">
				<xsl:apply-templates mode="elementEP" select="gmd:spatialRepresentationInfo|geonet:child[string(@name)='spatialRepresentationInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit" select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<!-- refSys tab -->
			<xsl:when test="$currTab='refSys'">
				<xsl:apply-templates mode="elementEP" select="gmd:referenceSystemInfo|geonet:child[string(@name)='referenceSystemInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit" select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<!-- distribution tab -->
			<xsl:when test="$currTab='distribution'">
				<xsl:apply-templates mode="elementEP" select="gmd:distributionInfo|geonet:child[string(@name)='distributionInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit" select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<!-- embedded distribution tab -->
			<xsl:when test="$currTab='distribution2'">
				<xsl:apply-templates mode="elementEP" select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit" select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<!-- dataQuality tab -->
			<xsl:when test="$currTab='dataQuality'">
				<xsl:apply-templates mode="elementEP" select="gmd:dataQualityInfo|geonet:child[string(@name)='dataQualityInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit" select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<!-- appSchInfo tab -->
			<xsl:when test="$currTab='appSchInfo'">
				<xsl:apply-templates mode="elementEP" select="gmd:applicationSchemaInfo|geonet:child[string(@name)='applicationSchemaInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit" select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<!-- porCatInfo tab -->
			<xsl:when test="$currTab='porCatInfo'">
				<xsl:apply-templates mode="elementEP" select="gmd:portrayalCatalogueInfo|geonet:child[string(@name)='portrayalCatalogueInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit" select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<!-- contentInfo tab -->
			<xsl:when test="$currTab='contentInfo'">
				<xsl:apply-templates mode="elementEP" select="gmd:contentInfo|geonet:child[string(@name)='contentInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit" select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<!-- extensionInfo tab -->
			<xsl:when test="$currTab='extensionInfo'">
				<xsl:apply-templates mode="elementEP" select="gmd:metadataExtensionInfo|geonet:child[string(@name)='metadataExtensionInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit" select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<!-- ISOMinimum tab -->
			<xsl:when test="$currTab='ISOMinimum'">
				<xsl:call-template name="isotabs">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit" select="$edit"/>
					<xsl:with-param name="dataset" select="$dataset"/>
					<xsl:with-param name="core" select="false()"/>
				</xsl:call-template>
			</xsl:when>
			
			<!-- ISOCore tab -->
			<xsl:when test="$currTab='ISOCore'">
				<xsl:call-template name="isotabs">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit" select="$edit"/>
					<xsl:with-param name="dataset" select="$dataset"/>
					<xsl:with-param name="core" select="true()"/>
				</xsl:call-template>
			</xsl:when>
			
			<!-- ISOAll tab -->
			<xsl:when test="$currTab='ISOAll'">
				<xsl:call-template name="iso19139Complete">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit" select="$edit"/>
				</xsl:call-template>
			</xsl:when>
			
			<!-- INSPIRE tab -->
			<xsl:when test="$currTab='inspire'">
				<xsl:call-template name="inspiretabs">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit" select="$edit"/>
					<xsl:with-param name="dataset" select="$dataset"/>
				</xsl:call-template>
			</xsl:when>
			
			<!-- RNDT tab -->
			<xsl:when test="$currTab='rndt'">
				<xsl:call-template name="rndttabs">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit" select="$edit"/>
					<xsl:with-param name="dataset" select="$dataset"/>
				</xsl:call-template>
			</xsl:when>
			
			<!-- default -->
			<xsl:otherwise>
				<xsl:call-template name="iso19139Simple">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit" select="$edit"/>
					<xsl:with-param name="flat" select="/root/gui/config/metadata-tab/*[name(.)=$currTab]/@flat"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- =================================================================== -->
	<!-- === Javascript used by functions in this presentation XSLT          -->
	<!-- =================================================================== -->
	<!-- Javascript used by functions in this XSLT -->
	<xsl:template name="iso19139.rndt-javascript">
		<!-- original iso19139-javascript is empty as well -->
		<!--
		<xsl:call-template name="iso19139-javascript" />
		-->
		
		<script type="text/javascript">
			<![CDATA[
				/**
				 * JavaScript Functions to support the RNDT Profile
				 */
				 				 
				/**
				 * RNDT: Utility function for Vertical CRS suggestions dropdown.  
				 */
				function setInputCRSel(elem, hrefId){
					var selectEl = elem;
					var input = document.getElementById(hrefId);
					var v = input.value;	
				   
				    if(selectEl.value == ""){
						input.value = "http://www.rndt.gov.it/ReferenceSystemCode#999";
					}else{
						if(input.value.indexOf("ReferenceSystemCode") != -1){
							input.value = "http://www.epsg-registry.org/export.htm?gml=urn:ogc:def:crs:" + selectEl.value;
						}else{
							input.value = v.substring(0, v.indexOf('EPSG')) + selectEl.value;
						}
					}
				}
				
				/**
				 * RNDT: gm:pass management
				 */
				function setConformityPass(sel, selRef, explRef){	
					if (sel.value.indexOf("non conforme") != -1) {
						$(selRef).value = 'false';
						$(explRef).value = 'non conforme';
					} else if (sel.value.indexOf("conforme") != -1) {	
						$(selRef).value = 'true';
						$(explRef).value = 'conforme';
					} else {
						$(selRef).value = 'false';
						$(explRef).value = sel.value;
					}
				}
				
                /**
				 * RNDT: Special validation function for the telephone/linkage in ResponsibleParty
				 */
				function validateNonEmpty_rndt(linkageElem, phoneRef){
					var phone = $(phoneRef);
					
					if(phone && phone.value.length < 1){
						if (linkageElem.value.length < 1) {
					        linkageElem.addClassName('error');
					        return false;
					    } else {
					        linkageElem.removeClassName('error');
					        return true;
					    }
					}else{
				        linkageElem.removeClassName('error');
				        return true;
					}
				}
				
				/**
				 * RNDT: Force the linkage validation when editing the phone
				 */
				function setValidationCheck_rndt(linkageElem, phoneRef){
					var phone = $(phoneRef);
					var linkage = $(linkageElem);
					
					if(phone){
						phone.onkeyup = function(){
							if(phone.value.length > 1){							
								linkage.removeClassName('error');
						        return true;
							}else if(linkage.value.length < 1){
								linkage.addClassName('error');
						        return false;
							}
						};
					}
				}
				
				// //////////////////////////////////////////////////////////////
				// Overvrite some core JS function introducing more controls 
				// on fields in order to avoid bugs when the user delete an 
				// element from the metadata edit page. 
				// //////////////////////////////////////////////////////////////
				
				/**
				 * See the original one in metadata-editor.js
				 */
				function topElement(el){
					if(el){
						if (el.previous() == undefined) return true;
						else return (!isSameElement(el.previous(),el));
					}else{
						return false;
					}
				}
				
				/**
				 * See the original one in metadata-editor.js
				 */
				function getControlsFromElement(el) {					
					elButtons = null;
					
				    if(el){
					    var id = el.getAttribute('id');
						elButtons = $('buttons_'+id);
						elButtons = elButtons ? elButtons.immediateDescendants() : elButtons;
					}
				
					return elButtons;
				}
				
				/**
				 * See the original one in metadata-editor.js
				 */
				function topControls(el, min){
					var elDescs = getControlsFromElement(el);
					
					if(elDescs){
						// Check addXmlFragment control
						var index = 0;
						if (elDescs.length == 5) index = 1;
						
						// sort out +
						if (bottomElement(el) && !orElement(el)) elDescs[0].show();
						else elDescs[0].hide();
						
						// sort out +/x (addXmlFragment)
						if (index == 1) {
							if (bottomElement(el) && !orElement(el))
								elDescs[index].show();
							else
								elDescs[index].hide();
						}
				
						// sort out x
						if (bottomElement(el)) {
							if (min == 0) elDescs[1+index].show();
							else elDescs[1+index].hide();
						} else elDescs[1+index].show();
				
						// sort out ^
						elDescs[2+index].hide();
				
						// sort out v
						if (bottomElement(el)) elDescs[3+index].hide();
						else elDescs[3+index].show();
					}
				}
				
				/**
				 * See the original one in metadata-editor.js
				 */
				function swapControls(el1, el2){
					var el1Descs = getControlsFromElement(el1);
					var el2Descs = getControlsFromElement(el2);
					for (var index = 0; index < el1Descs.length; ++index){
						var visible1 = null;
					 	if(el1Descs != null)
							visible1 = el1Descs[index].visible();
						
						var visible2 = null;	
					 	if(el2Descs != null)
							visible2 = el2Descs[index].visible();
					
				     	if(el2Descs != null){
					 		if (visible1) el2Descs[index].show();
							else el2Descs[index].hide();
					 	}	
				
					 	if(el1Descs != null){
							if (visible2) el1Descs[index].show();
							else el1Descs[index].hide();
					 	}
					}
				}
				
				/**
				 * See the original one in metadata-editor.js
				 */
				function doRemoveElementAction(action, ref, parentref, id, min){
					var metadataId = document.mainForm.id.value;
					var thisElement = $(id);
					var nextElement = thisElement.next();
					var prevElement = thisElement.previous();
					var myExtAJaxRequest = Ext.Ajax.request({
						url: getGNServiceURL(action),
						method: 'GET',
						params: {id:metadataId, ref:ref, parent:parentref},
						success: function(result, request) {
							var html = result.responseText;
							if (html.blank()) { 
								// /////////////////////////////////////////////////////////////////////
								// We have to ensure that the elements (thisElement and prevElement) 
								// are components of the same type before swapping controls (see later). 
								// Otherwise the risk is to swapp controls between different components 
								// types and this is an error.
								// /////////////////////////////////////////////////////////////////////
							    var prevIsSameSubComponent = false;
							    if(thisElement && prevElement){
							    	prevIsSameSubComponent = thisElement.id.split('_')[0] == prevElement.id.split('_')[0];
							    }
							    
							    // /////////////////////////////////////////////////////////////////////
								// We have to ensure that the elements (thisElement and nextElement) 
								// are components of the same type before set top controls (see later). 
								// Otherwise the risk is to set controls between different components 
								// types and this is an error.
								// /////////////////////////////////////////////////////////////////////
							    var nextIsSameSubComponent = false;
							    if(thisElement && nextElement){
							    	nextIsSameSubComponent = thisElement.id.split('_')[0] == nextElement.id.split('_')[0];
							    }
							    
							    // /////////////////////////////////////////////////////////////////
								// More than one left, no child-placeholder returned
							    // in simple mode, returned snippets will be empty in all cases
							    // because a geonet:child alone is not take into account.
							    // No elements are suggested then and last element is removed.
							    // //////////////////////////////////////////////////////////////////							    
								if (bottomElement(thisElement) && document.mainForm.currTab.value!='simple') { 
									if(prevIsSameSubComponent){
										swapControls(thisElement,prevElement);
									}									
									thisElement.remove();
									thisElement = prevIsSameSubComponent ? prevElement : undefined;
								} else {
									thisElement.remove();
									thisElement = nextIsSameSubComponent ? nextElement : undefined;
								}
								
								if (topElement(thisElement)){
									topControls(thisElement,min); 
								}
							} else { 
								// ///////////////////////////////////////////////////////
								// Last one, so replace with child-placeholder returned
								// ///////////////////////////////////////////////////////
								if (orElement(thisElement)) thisElement.remove();
								else thisElement.replace(html);
							} 
							setBunload(true); // Reset warning for window destroy
						},
						failure:function (result, request) { 
							Ext.MessageBox.alert(translate("errorDeleteElement") + name + " " + translate("errorFromDoc") 
										+ " / status " + result.status + " text: " + result.statusText + " - " + translate("tryAgain"));
							setBunload(true); // reset warning for window destroy
						}
					});
				}
				
			 ]]>
		</script>
	</xsl:template>
	
	<!-- Do not try do display element with no children in view mode -->
	<!-- Usually this should not happen because GeoNetwork will add default children like gco:CharacterString. 
		 Fixed #299
		 TODO : metadocument contains geonet:element which is probably not required ?
	-->
	<xsl:template mode="iso19139" priority="200" match="*[(@gco:nilReason='missing' or @gco:nilReason='unknown') and geonet:element and count(*)=1]"/>
	
	<xsl:template mode="iso19139" priority="200" match="*[geonet:element and count(*)=1 and text()='']"/>
	
	<!--<xsl:template mode="iso19139" match="gmd:DQ_AbsoluteExternalPositionalAccuracy">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<xsl:choose>
			<xsl:when test="$edit=true()">
                <!-\-<xsl:apply-templates mode="complexElement" select=".">
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="edit"   select="$edit"/>
                </xsl:apply-templates>-\->
            </xsl:when>
            <xsl:otherwise>
				<xsl:apply-templates mode="simpleElement" select=".">
					<xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="edit"   select="$edit"/>
                    <xsl:with-param name="text" select="."/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
        
	</xsl:template>-->

</xsl:stylesheet>
