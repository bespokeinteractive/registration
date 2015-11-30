<%--
 *  Copyright 2013 Society for Health Information Systems Programmes, India (HISP India)
 *
 *  This file is part of Registration module.
 *
 *  Registration module is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  Registration module is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Registration module.  If not, see <http://www.gnu.org/licenses/>.
 *  author: Ghanshyam
 *  date:   20-02-2013
--%>
<%@ include file="/WEB-INF/template/include.jsp" %>
<openmrs:globalProperty var="userLocation" key="hospital.location_user" defaultValue="false"/>

<script type="text/javascript">
	jQuery(document).ready(function(){
	    jQuery("#save").hide();	
		jQuery("#patientId").val(MODEL.patientId);
		jQuery("#revisit").val(MODEL.revisit);
		jQuery("#identifier").html(MODEL.patientIdentifier);
		jQuery("#age").html(MODEL.patientAge);
		jQuery("#name").html(MODEL.patientName);
		jQuery("#printablePaymentCategoryRow").hide();
		jQuery("#printableRoomToVisitRow").hide();
		jQuery("#fileNumberRowField").hide();
		jQuery("#printableFileNumberRow").hide();
		
		jQuery("#mlc").hide();
		
		jQuery("#buySlip").hide();
		
		jQuery("#specialSchemeNameField").hide();
		
		jQuery("#triageField").hide();
		jQuery("#opdWardField").hide();
		jQuery("#specialClinicField").hide();
		
        jQuery("#nationalId").html(MODEL.patientAttributes[20]);
		jQuery("#phoneNumber").html(MODEL.patientAttributes[16]);
		jQuery("#maritalStatus").html(MODEL.patientAttributes[26]);
		jQuery("#gender").html(MODEL.patientGender);
		jQuery("#datetime").html(MODEL.currentDateTime);
		jQuery("#patientName").html(MODEL.patientName);
		
		MODEL.TRIAGE = " ,Please Select Triage to Visit|" + MODEL.TRIAGE;
		PAGE.fillOptions("#triage", {
			data:MODEL.TRIAGE,
			delimiter: ",",
			optionDelimiter: "|"
		});
		
		MODEL.OPDs = " ,Please Select OPD to Visit|" + MODEL.OPDs;
		PAGE.fillOptions("#opdWard", {
			data:MODEL.OPDs,
			delimiter: ",",
			optionDelimiter: "|"
		});
		
		MODEL.SPECIALCLINIC = " ,Please Select Special Clinic to Visit|" + MODEL.SPECIALCLINIC;
		PAGE.fillOptions("#specialClinic", {
			data:MODEL.SPECIALCLINIC,
			delimiter: ",",
			optionDelimiter: "|"
		});
		
		MODEL.MEDICOLEGALCASE = " ,Please Select MEDICO LEGAL CASE|" + MODEL.MEDICOLEGALCASE;
		PAGE.fillOptions("#mlc", {
			data:MODEL.MEDICOLEGALCASE,
			delimiter: ",",
			optionDelimiter: "|"
		});
		
		// Set the selected triage
		if(!StringUtils.isBlank(MODEL.selectedTRIAGE)){	
		    jQuery("#triageField").show();		
			jQuery("#triage").val(MODEL.selectedTRIAGE);
			jQuery("#triage").attr("disabled", "disabled");
		}
		
		// Set the selected OPD
		if(!StringUtils.isBlank(MODEL.selectedOPD)){
		    jQuery("#opdWardField").show();
			jQuery("#opdWard").val(MODEL.selectedOPD);
			jQuery("#opdWard").attr("disabled", "disabled");
		}
		
		// Set the selected SPECIAL CLINIC
		if(!StringUtils.isBlank(MODEL.selectedSPECIALCLINIC)){
		    jQuery("#specialClinicField").show();
			jQuery("#specialClinic").val(MODEL.selectedSPECIALCLINIC);
			jQuery("#specialClinic").attr("disabled", "disabled");
		}
		
		if(!StringUtils.isBlank(MODEL.selectedMLC)){	
		    jQuery("#mlc").show();		
			jQuery("#mlc").val(MODEL.selectedMLC);	
			jQuery("#mlc").attr("disabled", "disabled");
		}
		
		
		
		jQuery("#paying").click(function() {
		VALIDATORS.payingCheck();
		});
		jQuery("#nonPaying").click(function() {
		VALIDATORS.nonPayingCheck();
		});
		jQuery("#specialSchemes").click(function() {
		VALIDATORS.specialSchemeCheck();
		});
		
		jQuery("#mlcCaseYes").click(function() {
		VALIDATORS.mlcYesCheck();
		});		
		jQuery("#mlcCaseNo").click(function() {
		VALIDATORS.mlcNoCheck();
		});
		
		jQuery("#triageRoom").click(function() {
		VALIDATORS.triageRoomCheck();
		});	
		jQuery("#opdRoom").click(function() {
		VALIDATORS.opdRoomCheck();
		});
		jQuery("#specialClinicRoom").click(function() {
		VALIDATORS.specialClinicRoomCheck();
		});
		
			if(!StringUtils.isBlank(MODEL.selectedTRIAGE) || !StringUtils.isBlank(MODEL.selectedOPD) || !StringUtils.isBlank(MODEL.selectedSPECIALCLINIC)){	
			jQuery("#triageRoomField").hide();
			jQuery("#opdRoomField").hide();
			jQuery("#specialClinicRoomField").hide();
			}
			
		
		    if(MODEL.patientAttributes[14]=="Paying"){
			var a=MODEL.patientAttributes[14];
			var b=MODEL.patientAttributes[44];
			var c=a+"/"+b;	
			jQuery("#printablePaymentCategory").append("<span style='border:0px'>" + c + "</span>");
			}
			
			if(MODEL.patientAttributes[14]=="Non-Paying"){
			var a=MODEL.patientAttributes[14];
			var b=MODEL.patientAttributes[45];
			if(MODEL.patientAttributes[45]=="NHIF CIVIL SERVANT"){
			var c=MODEL.patientAttributes[34];
			var d=a+"/"+b+"/"+c;
			jQuery("#printablePaymentCategory").append("<span style='border:0px'>" + d + "</span>");
			}
			else{
			var c=a+"/"+b;	
			jQuery("#printablePaymentCategory").append("<span style='border:0px'>" + c + "</span>");
			  }
			}
			
			if(MODEL.patientAttributes[14]=="Special Schemes"){	
			var a=MODEL.patientAttributes[14];
			var b=MODEL.patientAttributes[46];
			if(MODEL.patientAttributes[46]=="STUDENT SCHEME"){
			var c=MODEL.patientAttributes[47];
			var d=MODEL.patientAttributes[42];
			var e=a+"/"+b+"/"+c+"/"+d;
			jQuery("#printablePaymentCategory").append("<span style='border:0px'>" + e + "</span>");
			}
			else if(MODEL.patientAttributes[46]=="WAIVER CASE"){
			var c=MODEL.patientAttributes[32];
			var d=a+"/"+b+"/"+c;
			jQuery("#printablePaymentCategory").append("<span style='border:0px'>" + d + "</span>");
			}
			else{
			var c=a+"/"+b;
			jQuery("#printablePaymentCategory").append("<span style='border:0px'>" + c + "</span>");
			  }
			}
			jQuery("#printablePaymentCategoryRow").show();
			
		// Set data for first time visit,revisit,reprint
		if(MODEL.firstTimeVisit=="true"){
		    jQuery("#reprint").hide();
		    jQuery("#printableRegistrationFeeForFirstVisitAndReprintRow").hide();
			
			if(!StringUtils.isBlank(MODEL.selectedMLC)){
			jQuery("#mlcCaseYesField").hide();
			jQuery("#mlcCaseNoRowField").hide();
			}
			else{
			jQuery("#medicoLegalCaseRowField").hide();
		    jQuery("#mlcCaseNoRowField").hide();
			}	
			    
			jQuery("#triageRowField").hide();
			jQuery("#opdRowField").hide();
			jQuery("#specialClinicRowField").hide();
			
			jQuery("#printableRoomToVisitRow").show();
			if(!StringUtils.isBlank(MODEL.selectedTRIAGE)){	
			jQuery("#printableRoomToVisit").append("<span style='border:0px'>" + jQuery("#triage option:checked").html() + "</span>");
			}
            if(!StringUtils.isBlank(MODEL.selectedOPD)){
		    jQuery("#printableRoomToVisit").append("<span style='border:0px'>" + jQuery("#opdWard option:checked").html() + "</span>");
            }
            if(!StringUtils.isBlank(MODEL.selectedSPECIALCLINIC)){
		    jQuery("#printableRoomToVisit").append("<span style='border:0px'>" + jQuery("#specialClinic option:checked").html() + "</span>");
		    jQuery("#printableFileNumber").empty();
		    if(MODEL.patientAttributes[43]!=undefined){
            jQuery("#printableFileNumber").append("<span style='margin:5px;'>" + MODEL.patientAttributes[43] + "</span>");	
            }
		    jQuery("#printableFileNumberRow").show();
            }
			
		}
		else if(MODEL.revisit=="true"){
			jQuery("#reprint").hide();
			jQuery("#printableRegistrationFeeForRevisitRow").hide();
			jQuery("#selectedPaymentCategory").val(MODEL.patientAttributes[14]);
			if(MODEL.patientAttributes[14]=="Paying"){
            jQuery("#selectedPaymentSubCategory").val(MODEL.patientAttributes[44]);
            }
            if(MODEL.patientAttributes[14]=="Non-Paying"){
            jQuery("#selectedPaymentSubCategory").val(MODEL.patientAttributes[45]);
            }
            if(MODEL.patientAttributes[14]=="Special Schemes"){
            jQuery("#selectedPaymentSubCategory").val(MODEL.patientAttributes[46]);
            }
			
		}
		else if(MODEL.reprint=="true"){
			
			jQuery("#printableRegistrationFeeForFirstVisitAndReprintRow").hide();
			if(!StringUtils.isBlank(MODEL.selectedMLC)){
			jQuery("#mlcCaseYesField").hide();
			jQuery("#mlcCaseNoRowField").hide();
			}
			else{
			jQuery("#medicoLegalCaseRowField").hide();
		    jQuery("#mlcCaseNoRowField").hide();
			}	
			    
			jQuery("#triageRowField").hide();
			jQuery("#opdRowField").hide();
			jQuery("#specialClinicRowField").hide();
			
			if(!StringUtils.isBlank(MODEL.selectedMLC)){
			jQuery("#mlcCaseNoRowField").hide();
			}
			else{
			jQuery("#medicoLegalCaseRowField").hide();
		    jQuery("#mlcCaseNoRowField").hide();
			}	
			
			jQuery("#printableRoomToVisitRow").show();
			if(!StringUtils.isBlank(MODEL.selectedTRIAGE)){	
			jQuery("#printableRoomToVisit").append("<span style='border:0px'>" + jQuery("#triage option:checked").html() + "</span>");
			
			}
            if(!StringUtils.isBlank(MODEL.selectedOPD)){
		    jQuery("#printableRoomToVisit").append("<span style='border:0px'>" + jQuery("#opdWard option:checked").html() + "</span>");
            }
            if(!StringUtils.isBlank(MODEL.selectedSPECIALCLINIC)){
		    jQuery("#printableRoomToVisit").append("<span style='border:0px'>" + jQuery("#specialClinic option:checked").html() + "</span>");
		    jQuery("#printableFileNumber").empty();
		    if(MODEL.patientAttributes[43]!=undefined){
            jQuery("#printableFileNumber").append("<span style='margin:5px;'>" + MODEL.patientAttributes[43] + "</span>");
            }	
		    jQuery("#printableFileNumberRow").show();
            }
            
            //alert("hmmm");
           if((MODEL.create!=0)&&(MODEL.creates!=0)){ //alert("hiii");
           jQuery("#patientrevisit").hide();}
          else{ //alert("hello");
          	jQuery("#patientrevisit").show();
           }

			jQuery("#printSlip").hide();
			jQuery("#save").hide();
		}
		
	});
	
	/**
	 ** PAGE METHODS
	 **/
	PAGE = {
		/** Validate and submit */
		submit: function(reprint){
		
			if(PAGE.validate()){
				
				// Hide print button
				jQuery("#printSlip").hide();
				jQuery("#reprint").hide();
                
                if(MODEL.revisit=="true"){
			
			    if (jQuery("#mlcCaseYes").is(':checked')) {
		        jQuery("#mlcCaseNoRowField").hide();
		        jQuery("#mlcCaseYesField").hide();
		        jQuery("#mlc").hide();
		        jQuery("#mlc").after("<span style='border:0px'>" + jQuery("#mlc option:checked").html() +  "</span>");
			    }
			    else if (jQuery("#mlcCaseNo").is(':checked')) {
		        jQuery("#medicoLegalCaseRowField").hide();
		        jQuery("#mlcCaseNoRowField").hide();
			    }
			    
			    jQuery("#triageRowField").hide();
			    jQuery("#opdRowField").hide();
			    jQuery("#specialClinicRowField").hide();
			    
			    if (jQuery("#paying").is(':checked')) {
			     jQuery("#printablePaymentCategory").append("<span style='border:0px'>" + jQuery("#paying").val() + "</span>");
			    }
				                if (jQuery("#nonPaying").is(':checked')) {
                 jQuery("#printablePaymentCategory").append("<span style='border:0px'>" + jQuery("#nonPaying").val() + "</span>");
                }

                if (jQuery("#specialSchemes").is(':checked')) {
                 jQuery("#printablePaymentCategory").append("<span style='border:0px'>" + jQuery("#specialSchemes").val() + "</span>");
                }
                
                jQuery("#printablePaymentCategoryRow").show();	
			    
			    jQuery("#printableRoomToVisitRow").show();
			    if (jQuery("#triageRoom").is(':checked')) {
				jQuery("#printableRoomToVisit").append("<span style='border:0px'>" + jQuery("#triage option:checked").html() + "</span>");
			    }
                if (jQuery("#opdRoom").is(':checked')) {
				jQuery("#printableRoomToVisit").append("<span style='border:0px'>" + jQuery("#opdWard option:checked").html() + "</span>");
                }
                if (jQuery("#specialClinicRoom").is(':checked')) {
				jQuery("#printableRoomToVisit").append("<span style='border:0px'>" + jQuery("#specialClinic option:checked").html() + "</span>");
				jQuery("#printableFileNumber").empty();
				jQuery("#printableFileNumber").append("<span style='border:0px'>" + jQuery("#fileNumber").val() + "</span>");
		        jQuery("#fileNumberRowField").hide();
		        jQuery("#printableFileNumberRow").show();
                }
			    
                }
				
				// submit form and print		
				if(!reprint){
					jQuery("#patientInfoForm").ajaxSubmit({
						success: function (responseText, statusText, xhr){
							if(responseText=="success"){						
								PAGE.print();
								window.location.href = getContextPath() + "/findPatient.htm";
							}					
						}
					});
				} else {
					PAGE.print();
					window.location.href = getContextPath() + "/findPatient.htm";
				}
				
			}
		},
		
		// Print the slip
		print: function(){
			jQuery("#patientInfoPrintArea").printArea({
				mode : "popup",
				popClose : true
			});
		},
		
		// harsh #244 Added a save button.
		save: function(){
			if (PAGE.validate()){
			var save=document.getElementById("save");
			if(save==save){
			document.getElementById("save").disabled = true;
			}
			jQuery("#patientInfoForm").ajaxSubmit({
				success: function (responseText, statusText, xhr){
					if(responseText=="success"){						
					
						window.location.href = getContextPath() + "/findPatient.htm";
					}					
				}
			});
			}
			},

		
		
		/** FILL OPTIONS INTO SELECT 
		 * option = {
		 * 		data: list of values or string
		 *		index: list of corresponding indexes
		 *		delimiter: seperator for value and label
		 *		optionDelimiter: seperator for options
		 * }
		 */
		fillOptions: function(divId, option) {
			jQuery(divId).empty(); 
			if(option.delimiter == undefined){
				if(option.index == undefined){
					jQuery.each(option.data, function(index, value){	
						if(value.length>0){
							jQuery(divId).append("<option value='" + value + "'>" + value + "</option>");
						}
					});				
				} else {
					jQuery.each(option.data, function(index, value){	
						if(value.length>0){
							jQuery(divId).append("<option value='" + option.index[index] + "'>" + value + "</option>");
						}
					});
				}
			} else {
				options = option.data.split(option.optionDelimiter);
				jQuery.each(options, function(index, value){
					values = value.split(option.delimiter);
					optionValue = values[0];
					optionLabel = values[1];
					if(optionLabel != undefined){
						if(optionLabel.length>0){
							jQuery(divId).append("<option value='" + optionValue + "'>" + optionLabel + "</option>");
						}
					}					
				});
			}
		},
		
		/** Buy A New Slip */		
		buySlip: function(){
			jQuery.ajax({
				type : "GET",
				url : openmrsContextPath + "/module/registration/ajax/buySlip.htm",
				data : ({
					patientId: MODEL.patientId
				}),				
				success : function(data) {										
					window.location.href = window.location.href;
				},
				error : function(xhr, ajaxOptions, thrownError) {
					alert(thrownError);
				}
			});
		},
		
		/** Validate Form */
		validate: function(){
		
		
			
		if(MODEL.revisit=="true"){
                
			
		if (jQuery("#mlcCaseYes").attr('checked') == false
					&& jQuery("#mlcCaseNo").attr('checked') == false) {			
			    alert("You did not choose any of the Medico Legal Case ");
				return false;
			} else {
			
			   if (jQuery("#mlcCaseYes").is(':checked')) {
				if (StringUtils.isBlank(jQuery("#mlc").val())){
					alert("Please select the medico legal case");
					return false;
				}
			}
			
			}
		
			if (jQuery("#triageRoom").attr('checked') == false
				&& jQuery("#opdRoom").attr('checked') == false
				&& jQuery("#specialClinicRoom").attr('checked') == false) {			
			    alert("You did not choose any of the room");
				return false;
			} else {
			    if (jQuery("#triageRoom").attr('checked')) {
					if (StringUtils.isBlank(jQuery("#triage").val())) {
						alert("Please select the triage room to visit");
						return false;
					}
				}
				else if (jQuery("#opdRoom").attr('checked')){
				    if (StringUtils.isBlank(jQuery("#opdWard").val())) {
						alert("Please select the OPD room to visit");
						return false;
					}
				}
				else{
				    if (StringUtils.isBlank(jQuery("#specialClinic").val())) {
						alert("Please select the Special Clinic to visit");
						return false;
					}
					/*
					if (StringUtils.isBlank(jQuery("#fileNumber").val())) {
						alert("Please enter the File Number");
						return false;
					}
					*/
				}
			}
		 }
			
			return true;
		}
	};
	
	//ghanshyam  20-may-2013 #1648 capture Health ID and Registration Fee Type
	VALIDATORS = {
	
		/** CHECK WHEN PAYING CATEGORY IS SELECTED */
		payingCheck : function() {
			if (jQuery("#paying").is(':checked')) {
					jQuery("#nonPaying").removeAttr("checked");
				    
				    jQuery("#specialSchemes").removeAttr("checked");
					jQuery("#specialSchemeName").val("");
					jQuery("#specialSchemeNameField").hide();
			}
		},
		
		/** CHECK WHEN NONPAYING CATEGORY IS SELECTED */
		nonPayingCheck : function() {
			if (jQuery("#nonPaying").is(':checked')) {
					jQuery("#paying").removeAttr("checked");
				    
				    jQuery("#specialSchemes").removeAttr("checked");
					jQuery("#specialSchemeName").val("");
					jQuery("#specialSchemeNameField").hide();
			}
		},
		
		/** CHECK WHEN SPECIAL SCHEME CATEGORY IS SELECTED */
		specialSchemeCheck : function() {
			if (jQuery("#specialSchemes").is(':checked')) {
					jQuery("#paying").removeAttr("checked");
					
					jQuery("#nonPaying").removeAttr("checked");
					jQuery("#specialSchemeNameField").show();
			}
			else{
			 jQuery("#specialSchemeName").val("");
			jQuery("#specialSchemeNameField").hide();
			}
		},
		
		mlcYesCheck : function () {
			if (jQuery("#mlcCaseYes").is(':checked')) {
			        jQuery("#mlcCaseNo").removeAttr("checked");
					jQuery("#mlc").show();	
			}
			else{
			jQuery("#mlc").hide();	
			}
		},
		
		mlcNoCheck : function () {
			if (jQuery("#mlcCaseNo").is(':checked')) {
			    jQuery("#mlcCaseYes").removeAttr("checked");	
				jQuery("#mlc").hide();	
			}
		},
		
		triageRoomCheck : function () {
			if (jQuery("#triageRoom").is(':checked')) {
			        jQuery("#opdRoom").removeAttr("checked");
			        jQuery("#specialClinicRoom").removeAttr("checked");
					jQuery("#triageField").show();
					jQuery("#opdWard").val("");	
					jQuery("#opdWardField").hide();	
					jQuery("#specialClinic").val("");	
					jQuery("#specialClinicField").hide();
					jQuery("#fileNumberRowField").hide(); 	
			}
			else{
			jQuery("#triageField").hide();	
			}
		},
		
		opdRoomCheck : function () {
			if (jQuery("#opdRoom").is(':checked')) {
			        jQuery("#triageRoom").removeAttr("checked");
			        jQuery("#specialClinicRoom").removeAttr("checked");
			        jQuery("#triage").val("");
			        jQuery("#triageField").hide();
					jQuery("#opdWardField").show();
					jQuery("#specialClinic").val("");	
					jQuery("#specialClinicField").hide();
					jQuery("#fileNumberRowField").hide(); 
			}
			else{
			jQuery("#opdWardField").hide();	
			}
		},
		
		specialClinicRoomCheck : function () {
			if (jQuery("#specialClinicRoom").is(':checked')) {
			        jQuery("#triageRoom").removeAttr("checked");
			        jQuery("#opdRoom").removeAttr("checked");
			        jQuery("#triage").val("");
			        jQuery("#triageField").hide();
			        jQuery("#opdWard").val("");	
			        jQuery("#opdWardField").hide();
					jQuery("#specialClinicField").show();
					if (!StringUtils.isBlank(jQuery("#specialClinic").val())) {
                    jQuery("#fileNumberRowField").show();
                    }	
			}
			else{
			jQuery("#specialClinicField").hide();
			jQuery("#fileNumberRowField").hide();	
			}
		},
		
		
		
		categoryCheck : function() {
			
			if (jQuery("#paymentCategory").val() == "Paying") {
				
				jQuery("#specialSchemeName").val("");
				jQuery("#specialSchemeNameField").hide();
				
			} else if(jQuery("#paymentCategory").val() == "Non-Paying"){
				jQuery("#specialSchemeName").val("");
				jQuery("#specialSchemeNameField").hide();

		
			} else if(jQuery("#paymentCategory").val() == "Special Schemes"){
				jQuery("#specialSchemeNameField").show();
			}
		},
	};
	
function triageRoomSelection(){
if(MODEL.patientAttributes[14]=="Paying"){
	if((MODEL.create==0))
	{  //alert("Patient Revisit within 24 hr");
	// alert("hello");
jQuery("#selectedRegFeeValue").val(0);
jQuery("#patientrevisit").show();
if(MODEL.patientAttributes[44]=="CHILD LESS THAN 5 YEARS"){
jQuery("#selectedRegFeeValue").val(0);
}
	}
else
{
	jQuery("#selectedRegFeeValue").val('${reVisitFee}');
	if(MODEL.patientAttributes[44]=="CHILD LESS THAN 5 YEARS"){
	jQuery("#selectedRegFeeValue").val(${childLessThanFiveYearRegistrationFee});
	}
	}
}

if(MODEL.patientAttributes[14]=="Non-Paying"){
jQuery("#selectedRegFeeValue").val(0);
}

if(MODEL.patientAttributes[14]=="Special Schemes"){
jQuery("#selectedRegFeeValue").val(0);
}

var selectedRegFeeValue=jQuery("#selectedRegFeeValue").val();
jQuery("#printableRegistrationFee").empty();
jQuery("#printableRegistrationFee").append("<span style='margin:5px;'>" + selectedRegFeeValue + "</span>");	
			
}

function opdRoomSelection(){
	if((MODEL.patientAttributes[14]=="Paying")){
	//	alert("hii");		
		if((MODEL.create==0))
			{
			// alert("Patient Revisit within 24 hr");
			  jQuery("#selectedRegFeeValue").val(0); 
				  jQuery("#patientrevisit").show();
			  
	if(MODEL.patientAttributes[44]=="CHILD LESS THAN 5 YEARS"){
	jQuery("#selectedRegFeeValue").val(0);
	//jQuery("#selectedRegFeeValue").show("(Patient Revisit within 24 hr)");
	}
			}
		else
		{
			jQuery("#selectedRegFeeValue").val('${reVisitFee}');
			if(MODEL.patientAttributes[44]=="CHILD LESS THAN 5 YEARS"){
			jQuery("#selectedRegFeeValue").val(${childLessThanFiveYearRegistrationFee});
			}
			}
	}
	
	if(MODEL.patientAttributes[14]=="Non-Paying"){
	jQuery("#selectedRegFeeValue").val(0);
	}

	if(MODEL.patientAttributes[14]=="Special Schemes"){
	jQuery("#selectedRegFeeValue").val(0);
	}

	var selectedRegFeeValue=jQuery("#selectedRegFeeValue").val();
	jQuery("#printableRegistrationFee").empty();
	jQuery("#printableRegistrationFee").append("<span style='margin:5px;'>" + selectedRegFeeValue + "</span>");	

	}

function specialClinicSelection(){

if (!StringUtils.isBlank(jQuery("#specialClinic").val())) {
jQuery("#fileNumberRowField").show();
if(MODEL.patientAttributes[43]!=null){
jQuery("#fileNumber").val(MODEL.patientAttributes[43]);
jQuery("#fileNumber").attr("disabled", "disabled");
}
}
else{
jQuery("#fileNumberRowField").hide();
}

if(MODEL.patientAttributes[14]=="Paying"){
	if((MODEL.create==0))
	{    //alert("Patient Revisit within 24 hr");
		jQuery("#selectedRegFeeValue").val(0);
		  jQuery("#patientrevisit").show();
		if(MODEL.patientAttributes[44]=="CHILD LESS THAN 5 YEARS"){
		jQuery("#selectedRegFeeValue").val(0);
		}
				}
	else
		{
var reVisitRegFee=parseInt('${reVisitFee}');
var specialClinicRegFee=parseInt('${specialClinicRegFee}');
var totalRegFee= reVisitRegFee+specialClinicRegFee;
jQuery("#selectedRegFeeValue").val(totalRegFee);
if(MODEL.patientAttributes[44]=="CHILD LESS THAN 5 YEARS"){
jQuery("#selectedRegFeeValue").val(${childLessThanFiveYearRegistrationFee});
}
		}
}

if(MODEL.patientAttributes[14]=="Non-Paying"){
jQuery("#selectedRegFeeValue").val(0);
if(MODEL.patientAttributes[45]=="TB PATIENT"){
jQuery("#selectedRegFeeValue").val(${specialClinicRegFee});
}
if(MODEL.patientAttributes[45]=="CCC PATIENT"){
jQuery("#selectedRegFeeValue").val(${specialClinicRegFee});
}
}

if(MODEL.patientAttributes[14]=="Special Schemes"){
jQuery("#selectedRegFeeValue").val(0);
}

var selectedRegFeeValue=jQuery("#selectedRegFeeValue").val();
jQuery("#printableRegistrationFee").empty();
jQuery("#printableRegistrationFee").append("<span style='margin:5px;'>" + selectedRegFeeValue + "</span>");	

}
</script>

<input id="printSlip" type="button" value="Print"
	onClick="PAGE.submit(false);" />
<input id="reprint" type="button" value="Reprint"
	onClick="PAGE.submit(true);" />
<input id="buySlip" type="button" value="Buy a new slip"
	onClick="PAGE.buySlip();" />
<input id="save" type="button" value="Save" onClick="PAGE.save();" />
<span id="validationDate"></span>
<div id="patientInfoPrintArea" style="width: 1280px; font-size: 0.8em">
<style>
	.donotprint {
		display: none;
	}
	.spacer {
		
		font-family: "Dot Matrix Normal", Arial, Helvetica, sans-serif;
		font-style: normal;
		font-size: 14px;
	}
	.printfont {
		font-family: "Dot Matrix Normal", Arial, Helvetica, sans-serif;
		font-style: normal;
		font-size: 14px;
	}

</style>
	<center>
	<center><img width="100" height="100" align="center" title="OpenMRS" alt="OpenMRS" src="${pageContext.request.contextPath}/moduleResources/registration/kenya_logo.bmp"><center>
		<form id="patientInfoForm" method="POST" class="spacer" style="margin-left: 20px;">
			<table class="spacer" style="margin-left: 20px;">
			<tr><h3><center><u><b>${userLocation} </b></u></center></h3></tr>
						<tr><h4><center><b>${typeOfSlip}</b></center></h4></tr>
				<tr>
					<td colspan="1"><b>Previous Day of Visit:</b></td>
					<td colspan="5"><span id="datetime"></span></td>
				</tr>
				<tr>
					<td colspan="1"><b>Name:</b></td>
					<td><span id="patientName"></span></td>
				</tr>
				<tr>
					<td colspan="1"><b>Patient ID:</b></td>
					<td colspan="5"><span id="identifier"></span></td>
				</tr>				
				<tr id="ageField">
					<td colspan="1"><b>Age:</b></td>
					<td colspan="5"><span id="age"></span></td>
				</tr>
				<tr id="genderField">
					<td colspan="1"><b>Gender:</b></td>
					<td colspan="5"><span id="gender"></span></td>
				</tr>
				
				<tr>
<!--					<td colspan="1"><b>Marital Status:</b></td>
					<td colspan="1"><span id="maritalStatus"></span></td> -->
					<td></td><td></td>
					
				</tr>
		
		<tr id="printablePaymentCategoryRow">
					<td><b>Payment Category:</b></td>
					<td>
						<div id="printablePaymentCategory"></div>
					</td>
		</tr>
		
				
				<%-- ghanshyam 27-02-2013 Feedback #966[Billing]Add Paid Bill/Add Free Bill for Bangladesh module(remove category from registration,OPD,IPD,Inventory)--%>
				<%--
				<tr>
					<td colspan="1"><b>Category:</b></td>
					<td colspan="1"  ><span id="category" /></td>
					<td><span id="FREE" /></td>
				</tr>
				--%>
				<!--
				<tr>
					<td colspan="1"><b>National ID:</b></td>
					<td colspan="1"><span id="nationalId"></span></td>
				</tr>
				-->
				<%-- ghanshyam  20-may-2013 #1648 capture Health ID and Registration Fee Type 
				
				<tr id="regFeeType">
					<td><b> <font color="red"> Registration Fee Type:</font> </b>
					</td>
					<td><input id="paidReg" type="checkbox"
						name="patient.registration.fee.attribute.${regFeeConId}" value="${regFee}" onClick="paidClick();" />
						Paid</td>
					<td><input id="freeReg" type="checkbox"
						name="patient.registration.fee.attribute.${regFeeConId}" value="0" onClick="freeClick();" /> Free</td>
					<td><span id="freeRegField">Reason <input
							id="freeRegReason"
							name="patient.registration.fee.free.reason.attribute.${regFeeReasonConId}" /> </span></td>
					<td><span style="color:red;" id="message" > </span></td>
				</tr> --%>
				
				<tr id="medicoLegalCaseRowField">
				<td><b>Medico Legal Case:</b><label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td id="mlcCaseYesField"><input id="mlcCaseYes" type="checkbox" name="mlcCaseYes"/> Yes &nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><select id="mlc" name="patient.mlc" style='width: 152px;'>	</select></td>
		</tr>
		<tr id="mlcCaseNoRowField">
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td id="mlcCaseNoField"><input id="mlcCaseNo" type="checkbox" name="mlcCaseNo"/> No &nbsp;&nbsp;&nbsp;&nbsp;</td>
		</tr>
		
		
		<tr id="triageRowField">
				<td><b>Room to Visit:</b><label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td id="triageRoomField"><input id="triageRoom" type="checkbox" name="triageRoom"/> Triage Room &nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td id="triageField"><select id="triage" name="patient.triage" onchange="triageRoomSelection();" style='width: 152px;'>	</select></td>
		</tr>
		<tr id="opdRowField">
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td id="opdRoomField"><input id="opdRoom" type="checkbox" name="opdRoom"/> OPD Room&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td id="opdWardField"><select id="opdWard" name="patient.opdWard" onchange="opdRoomSelection();" style='width: 152px;'>	</select></td>
		</tr>
		<tr id="specialClinicRowField">
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td id="specialClinicRoomField"><input id="specialClinicRoom" type="checkbox" name="specialClinicRoom"/> Special Clinic&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td id="specialClinicField"><select id="specialClinic" name="patient.specialClinic" onchange="specialClinicSelection();" style='width: 152px;'>	</select></td>
		</tr>
		<tr id="fileNumberRowField">
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td id="fileNumberField"><input id="fileNumber" name="person.attribute.43" placeholder="File Number" style='width: 152px;'/></td>
		</tr>
		<tr id="printableRoomToVisitRow">
				<td><b>Room to Visit:</b></td>
				<td>
				<div id="printableRoomToVisit"></div>
				</td>
		</tr>
		<tr id="printableFileNumberRow">
				<td><b>File Number:</b></td>
				<td>
				<div id="printableFileNumber"></div>
				</td>
		</tr>
	
		<tr id="printableRegistrationFeeForRevisitRow">			
				<td><b>Registration Fee:</b></td>
				<td>${registrationFee}</td>
		</tr>
		
	
		<tr id="printableRegistrationFeeForFirstVisitAndReprintRow">
				<td><b>Registration Fee:</b></td>
				<td>
				<div id="printableRegistrationFee"></div>
				</td>
		</tr>
 <tr style="display:none" id="patientrevisit">
						<td colspan="3"  align="left"><font color="#ff0000 ">(Patient Revisit with in 24 hr) </font></td> </tr>
	
		<tr id="printableUserRow">			
				<td><b>You were served by:</b>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>${user}</td>
		</tr>
		<tr>
				<td><input type="hidden" id="selectedPaymentCategory" name="patient.selectedPaymentCategory" /></td>
				<td><input type="hidden" id="selectedPaymentSubCategory" name="patient.selectedPaymentSubCategory" /></td>
				<td><input type="hidden" id="selectedRegFeeValue" name="patient.registration.fee" /></td>
		</tr>
			</table>
		</form>
	</center>
</div>
