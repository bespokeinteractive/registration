<%--
 *  Copyright 2014 Society for Health Information Systems Programmes, India (HISP India)
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
 *  
 *  
--%>

<style>
.cell {
	border-top: 2px solid black;
	padding: 20px;
}


td.border {
	border-width: 1px;
	border-right: 1px;
	border-left: 1px;
	border-top: 1px;
	border-bottom: 1px;
	border-color: black	;
	border-style: solid;
}

.floatLeft {
	width: 47%;
	float: left;
}

.floatRight {
	width: 52%;
	float: right;
}

.floatBottom {
	position : absolute;
    bottom : 0;
    height : 100px;
    margin-top : 100px;
	right : 50%;
}

.container {
	overflow: hidden;
}

input, select, textarea {

	border-width: 1px;
	border-right: 1px;
	border-left: 1px;
	border-top: 1px;
	border-bottom: 1px;
	border-color: black;
	border-style: solid;

}

</style>
<script type="text/javascript">
	jQuery(document).ready(
			function() {
				jQuery("#patientRegistrationForm").fillForm(
						"patient.identifier==" + MODEL.patientIdentifier);
				jQuery('#calendar').datepicker({
					yearRange : 'c-100:c+100',
					dateFormat : 'dd/mm/yy',
					changeMonth : true,
					changeYear : true
				});
				jQuery('#birthdate').change(PAGE.checkBirthDate);
				PAGE.fillOptions("#districts", {
					data : MODEL.districts
				});
				PAGE.fillOptions("#upazilas", {
					data : typeof(MODEL.upazilas[0])=="undefined"?MODEL.upazilas:MODEL.upazilas[0].split(',')
				});
				MODEL.TRIAGE = " ,Please Select Triage Room to Visit|"
						+ MODEL.TRIAGE;
				PAGE.fillOptions("#triage", {
					data : MODEL.TRIAGE,
					delimiter : ",",
					optionDelimiter : "|"
				});
				MODEL.TEMPORARYCAT = " ,Please select Temporary Category|"
						+ MODEL.TEMPORARYCAT;
				PAGE.fillOptions("#tempCat", {
					data : MODEL.TEMPORARYCAT,
					delimiter : ",",
					optionDelimiter : "|"
				});
							
				MODEL.referredFrom = " , |"
						+ MODEL.referredFrom;
				PAGE.fillOptions("#referredFrom", {
					data : MODEL.referredFrom,
					delimiter : ",",
					optionDelimiter : "|"
				});
				MODEL.referralType = " , |"
						+ MODEL.referralType;
				PAGE.fillOptions("#referralType	", {
					data : MODEL.referralType,
					delimiter : ",",
					optionDelimiter : "|"
				});

				jQuery("#searchbox").showPatientSearchBox(
						{
							searchBoxView : hospitalName + "/registration",
							resultView : "/module/registration/patientsearch/"
									+ hospitalName + "/findCreatePatient",
							success : function(data) {
								PAGE.searchPatientSuccess(data);
							},
							beforeNewSearch : PAGE.searchPatientBefore
						});


				// hide exemption and waver number
				jQuery("#exemptionField1").hide();
				jQuery("#exemptionField2").hide();
				jQuery("#nhifCardField1").hide();
				jQuery("#nhifCardField2").hide();
				jQuery("#waiverField1").hide();
				jQuery("#waiverField2").hide();
				jQuery("#catGen").hide();
				jQuery("#patCatGeneral").attr("checked", "checked");
				//jQuery("#hide_show").hide();
				jQuery("#tempCat").hide();
				jQuery("#healthIdField").hide();
				jQuery("#otherNationality").hide();
				// binding
				jQuery("#patCatGeneral").click(function() {
					VALIDATORS.generalCheck();
				});
				jQuery("#patCatHIV").click(function() {
					VALIDATORS.hivCheck();
				});
				jQuery("#patCatChildLessThan5yr").click(function() {
					VALIDATORS.childYearCheck();
				});
				jQuery("#patCatNHIF").click(function() {
					VALIDATORS.nhifCheck();
				});
				jQuery("#patCatTB").click(function() {
					VALIDATORS.tvCheck();
				});
				jQuery("#patCatMother").click(function() {
					VALIDATORS.motherCheck();
				});
				jQuery("#patCatOtherInsurance").click(function() {
					VALIDATORS.otherInsuranceCheck();
				});
				jQuery("#patCatMalaria").click(function() {
					VALIDATORS.malariaCheck();
				});
				jQuery("#patCatWaiver").click(function() {
					VALIDATORS.waiverCheck();
				});

				jQuery("#mlcCase").click(function() {
					VALIDATORS.tempCatCheck();
				});

				jQuery("#sameAddress").click(function() {
					VALIDATORS.copyaddress();
				});

				
				// hide free reason
				
				jQuery("#calendarButton").click(function() {
					jQuery("#calendar").datepicker("show");
				});
				jQuery("#calendar").change(function() {
					jQuery("#birthdate").val(jQuery(this).val());
					PAGE.checkBirthDate();
				});
				jQuery("#birthdate").click(function() {
					jQuery("#birthdate").select();
				});
				jQuery("#patientGender").change(function() {
					VALIDATORS.genderCheck();
				});

			});

	/**
	 ** FORM
	 **/
	PAGE = {
		/** SUBMIT */
		submit : function() {

			// Capitalize fullname and relative name
			fullNameInCapital = StringUtils.capitalize(jQuery("#nameOrIdentifier", jQuery("#patientSearchForm")).val());
			jQuery("#surName", jQuery("#patientRegistrationForm")).val(fullNameInCapital);
			//jQuery("#firstName", jQuery("#patientRegistrationForm")).val(fullNameInCapital);
			//jQuery("#givenName", jQuery("#patientRegistrationForm")).val(fullNameInCapital);
			//jQuery("#otherName", jQuery("#patientRegistrationForm")).val(fullNameInCapital);
			jQuery("#nameOrIdentifier", jQuery("#patientSearchForm")).val(fullNameInCapital);
			
			relativeNameInCaptital = StringUtils.capitalize(jQuery("#patientRelativeName").val());
			jQuery("#patientRelativeName").val(relativeNameInCaptital);

			// Validate and submit
			if (this.validateRegisterForm()) {
				jQuery("#patientRegistrationForm")
						.mask(
								"<img src='" + openmrsContextPath + "/moduleResources/hospitalcore/ajax-loader.gif" + "'/>&nbsp;");
				jQuery("#patientRegistrationForm")
						.ajaxSubmit(
								{
									success : function(responseText,
											statusText, xhr) {
										json = jQuery.parseJSON(responseText);
										if (json.status == "success") {
											window.location.href = openmrsContextPath
													+ "/module/registration/showPatientInfo.form?patientId="
													+ json.patientId
													+ "&encounterId="
													+ json.encounterId;
										} else {
											alert(json.message);
										}
										jQuery("#patientRegistrationForm")
												.unmask();
									}
								});
			}
		},
		
		 //ghanshya,3-july-2013 #1962 Create validation for length of Health ID and National ID
		//Add Validation for checking duplicate National Id and Health Id
		checkNationalIDPassportNumber : function() {
				
		        //healthId=jQuery("#patientHealthId").val();
				nationalId=jQuery("#patientNationalId").val();
				passportNumber=jQuery("#passportNumber").val();
				
				jQuery.ajax({
				type : "GET",
				url : getContextPath() + "/module/registration/validatenationalidandpassportnumber.form",
				data : ({
					nationalId			: nationalId,
					passportNumber		: passportNumber
				}),
				success : function(data) {	
				    jQuery("#validationMessage").html(data);	
					 
		           } 
               });
			},
		/** VALIDATE BIRTHDATE */
		checkBirthDate : function() {
			jQuery
					.ajax({
						type : "GET",
						url : getContextPath()
								+ "/module/registration/ajax/processPatientBirthDate.htm",
						data : ({
							birthdate : $("#birthdate").val()
						}),
						dataType : "json",
						success : function(json) {
							if (json.error == undefined) {
								if (json.estimated == "true") {
									jQuery("#birthdateEstimated").val("true")
								} else {
									jQuery("#birthdateEstimated").val("false");
								}
								jQuery("#estimatedAge").html(json.age);
								jQuery("#birthdate").val(json.birthdate);
								jQuery("#calendar").val(json.birthdate);

							} else {
								alert(json.error);
								jQuery("#birthdate").val("");
							}
						},
						error : function(xhr, ajaxOptions, thrownError) {
							alert(thrownError);
						}
					});
		},

		/** FILL OPTIONS INTO SELECT 
		 * option = {
		 * 		data: list of values or string
		 *		index: list of corresponding indexes
		 *		delimiter: seperator for value and label
		 *		optionDelimiter: seperator for options
		 * }
		 */
		fillOptions : function(divId, option) {
			jQuery(divId).empty();
			if (option.delimiter == undefined) {
				if (option.index == undefined) {
					jQuery.each(option.data, function(index, value) {
						if (value.length > 0) {
							jQuery(divId).append(
									"<option value='" + value + "'>" + value
											+ "</option>");
						}
					});
				} else {
					jQuery.each(option.data, function(index, value) {
						if (value.length > 0) {
							jQuery(divId).append(
									"<option value='" + option.index[index] + "'>"
											+ value + "</option>");
						}
					});
				}
			} else {
				options = option.data.split(option.optionDelimiter);
				jQuery.each(options, function(index, value) {
					values = value.split(option.delimiter);
					optionValue = values[0];
					optionLabel = values[1];
					if (optionLabel != undefined) {
						if (optionLabel.length > 0) {
							jQuery(divId).append(
									"<option value='" + optionValue + "'>"
											+ optionLabel + "</option>");
						}
					}
				});
			}
		},

		/** CHANGE DISTRICT */
		changeDistrict : function() {

			// get the list of upazilas
			upazilaList = "";
			selectedDistrict = jQuery("#districts option:checked").val();
			jQuery.each(MODEL.districts, function(index, value) {
				if (value == selectedDistrict) {
					upazilaList = MODEL.upazilas[index];
				}
			});

			// fill upazilas into upazila dropdown
			this.fillOptions("#upazilas", {
				data : upazilaList.split(",")
			});
		},

		/** SHOW OR HIDE REFERRAL INFO */
		toogleReferralInfo : function(obj) {
			checkbox = jQuery(obj);
			if (checkbox.is(":checked")) {
				jQuery("#referralDiv").show();
			} else {
				jQuery("#referralDiv").hide();
			}
		},

		/** CALLBACK WHEN SEARCH PATIENT SUCCESSFULLY */
		searchPatientSuccess : function(data) {
			jQuery("#numberOfFoundPatients")
					.html(
							"Similar Patients: "
									+ data.totalRow
									+ "(<a href='javascript:PAGE.togglePatientResult();'>Show/Hide</a>)");
		},

		/** CALLBACK WHEN BEFORE SEARCHING PATIENT */
		searchPatientBefore : function(data) {
			jQuery("#numberOfFoundPatients")
					.html(
							"<center><img src='" + openmrsContextPath + "/moduleResources/hospitalcore/ajax-loader.gif" + "'/></center>");
			jQuery("#patientSearchResult").hide();
		},

		/** TOGGLE PATIENT RESULT */
		togglePatientResult : function() {
			jQuery("#patientSearchResult").toggle();
		},

		/** VALIDATE FORM */
		validateRegisterForm : function() {

			if (StringUtils.isBlank(jQuery("#surName").val())) {
				alert("Please enter the surname of the patient");
				return false;
			}
			else{
			    value = jQuery("#surName").val();
				value = value.toUpperCase();
				pattern = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -";
				for (i = 0; i < value.length; i++) {
					if (pattern.indexOf(value[i]) < 0) {
						alert("Please enter surname/identifier in correct format");
						return false;
					}
				}
			}
			
			if (StringUtils.isBlank(jQuery("#firstName").val())) {
				alert("Please enter the first name of the patient");
				return false;
			}
			else{
			    value = jQuery("#firstName").val();
				value = value.substr(0, 1).toUpperCase() + value.substr(1);
				jQuery("#firstName").val(value);
				if(/^[a-zA-Z0-9- ]*$/.test(value) == false) {
					alert('Please enter firstname in correct format');
				}
				
			}
			
			if (!StringUtils.isBlank(jQuery("#givenName").val())) {
				value = jQuery("#givenName").val();
				value = value.substr(0, 1).toUpperCase() + value.substr(1);
				jQuery("#givenName").val(value);
				if(/^[a-zA-Z0-9- ]*$/.test(value) == false) {
					alert('Please enter givenname in correct format');
				}
			}
			if (!StringUtils.isBlank(jQuery("#otherName").val())) {
				value = jQuery("#otherName").val();
				value = value.substr(0, 1).toUpperCase() + value.substr(1);
				jQuery("#otherName").val(value);
				if(/^[a-zA-Z0-9- ]*$/.test(value) == false) {
					alert('Please enter othername in correct format');
				}
			}
	
				

			if (StringUtils.isBlank(jQuery("#patientRelativeName").val())) {
				alert("Please enter the patient's relative name");
				return false;
			} /*else {
				if (jQuery("#patientGender").val() == "M"||jQuery("#patientGender").val() == "F") {
					if (jQuery("#patientRegistrationForm input[name=person.attribute.15]:checked").length == 0) {
						alert("Please select relative name type");
						return false;
					}
				}
			}*/
			
			if (jQuery("#relationshipType").val() == "Relationship") {
				alert("Please enter the patient's relationship type with the NOK");
				return false;
			}

			if (StringUtils.isBlank(jQuery("#birthdate").val())) {
				alert("Please enter age or DOB of the patient");
				return false;
			} 

			if (!StringUtils.isBlank(jQuery("#referredFrom").val())) {
				if (StringUtils.isBlank(jQuery("#referralType").val())) {
					alert("Please enter referral type of the patient");
					return false;
				} 
			}	
			
			if (jQuery("#patientGender").val() == "Any") {
				alert("Please select gender of the patient");
				return false;
			} 
			
			/*if (jQuery("#maritalStatus").val() == "Marital") {
				alert("Please select marital status of the patient");
				return false;
			} 
			*/
			
			if (jQuery("#mlcCase").is(':checked')) {
				if (StringUtils.isBlank(jQuery("#tempCat").val()))
					{
					alert("Please select the patient's temporary category");
					return false;
					}
			}
					
			
			if (StringUtils.isBlank(jQuery("#patientPostalAddress").val())) {
				alert("Please enter the physical address of the patient");
				return false;
			}

			if (jQuery("#patientGender").val() == "M" &&  jQuery("#maritalStatus").val() == "Widow") {
				alert("Widow marital status is only for Female");
				return false;
			}		

			if (jQuery("#patientGender").val() == "F" &&  jQuery("#maritalStatus").val() == "Widower") {
				alert("Widower marital status is only for Male");
				return false;
			}		
			
			if (StringUtils.isBlank(jQuery("#triage").val())) {
				alert("Please select the triage room to visit");
				return false;
			}
			
			
 
			if (!StringUtils.isBlank(jQuery("#patientPhoneNumber").val())) {
				if (!StringUtils.isDigit(jQuery("#patientPhoneNumber").val())) {
					alert("Please enter the patient's contact number in correct format");
					return false;
				}
			}
			
			/*if (!StringUtils.isBlank(jQuery("#patientEmail").val())) {
				var x=jQuery("#patientEmail").val();
				var atpos=x.indexOf("@");
				var dotpos=x.lastIndexOf(".");
				if (atpos<1 || dotpos<atpos+2 || dotpos+2>=x.length)
				  {
				  alert("Please enter the patient's e-mail address in correct format");
				  return false;
				  }
			}
			
			
			if (!StringUtils.isBlank(jQuery("#relativeEmail").val())) {
				var x=jQuery("#relativeEmail").val();
				var atpos=x.indexOf("@");
				var dotpos=x.lastIndexOf(".");
				if (atpos<1 || dotpos<atpos+2 || dotpos+2>=x.length)
				  {
				  alert("Please enter the NOK's e-mail address in correct format");
				  return false;
				  }
			}*/
			
			if (!StringUtils.isBlank(jQuery("#patientEmail").val())) {
			var x=jQuery("#patientEmail").val();
			var regExpForEmail = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
			if (regExpForEmail.test(x)) {
			return true;
			}
			else {
			alert("Please enter the patient's e-mail address in correct format");
			return false;
			}
			
			}
			
			if (!StringUtils.isBlank(jQuery("#relativeEmail").val())) {
			var x=jQuery("#relativeEmail").val();
			var regExpForEmail = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
			if (regExpForEmail.test(x)) {
			return true;
			}
			else {
			alert("Please enter the NOK's e-mail address in correct format");
			return false;
			}
			}
			
			if (!StringUtils.isBlank(jQuery("#relativePhoneNumber").val())) {
				if (!StringUtils.isDigit(jQuery("#relativePhoneNumber").val())) {
					alert("Please enter the NOK's contact number in correct format");
					return false;
				}
			}
			
			if (!StringUtils.isBlank(jQuery("#estimatedAge").html())) {
				estAge = jQuery("#estimatedAge").html();
				var rest=estAge.slice(1,-6); 
				if (rest>5) {
					if (jQuery("#patCatChildLessThan5yr").is(':checked')) {
						alert("This category is only valid for patient under 5 years of age");
						jQuery("#patCatChildLessThan5yr").removeAttr("checked");
						jQuery("#exemptionNumber").val("");
						jQuery("#exemptionField1").hide();
						jQuery("#exemptionField2").hide();
						//jQuery("#bdate").show();
						return false;
					}
				}
			}

			if (jQuery("#patientGender").val() == "M" && jQuery("#patCatMother").is(':checked') ) {
					jQuery("#patCatMother").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
					jQuery("#exemptionField2").hide();
					alert("This category is only valid for female patient");
					return false;
				}		
			
			
			if (jQuery("#patCatGeneral").attr('checked') == false
					&& jQuery("#patCatHIV").attr('checked') == false
					&& jQuery("#patCatChildLessThan5yr").attr('checked') == false
					&& jQuery("#patCatNHIF").attr('checked') == false
					&& jQuery("#patCatTB").attr('checked') == false
					&& jQuery("#patCatMother").attr('checked') == false
					&& jQuery("#patCatOtherInsurance").attr('checked') == false
					&& jQuery("#patCatMalaria").attr('checked') == false
					&& jQuery("#patCatWaiver").attr('checked') == false) {
				jQuery("#patCatGeneral").attr("checked", "checked");				
			//	alert('You didn\'t choose any of the patient categories!');
				return true;
			} else {
			    if (jQuery("#patCatHIV").attr('checked')) {
					if (jQuery("#exemptionNumber").val().length <= 0) {
						alert('Please enter the Exemption Number');
						return false;
					}
				}
				
				if (jQuery("#patCatChildLessThan5yr").attr('checked')) {
					if (jQuery("#exemptionNumber").val().length <= 0) {
						alert('Please enter the Exemption Number');
						return false;
					}
				}
				
				if (jQuery("#patCatNHIF").attr('checked')) {
					if (jQuery("#exemptionNumber").val().length <= 0) {
						alert('Please enter the Exemption Number');
						return false;
					}
					
					if (jQuery("#nhifCardNumber").val().length <= 0) {
						alert('Please enter the NHIF Card Number');
						return false;
					}
				}
				
				if (jQuery("#patCatTB").attr('checked')) {
					if (jQuery("#exemptionNumber").val().length <= 0) {
						alert('Please enter the Exemption Number');
						return false;
					}
				}

				if (jQuery("#patCatMother").attr('checked')) {
					if (jQuery("#exemptionNumber").val().length <= 0) {
						alert('Please enter the Exemption Number');
						return false;
					}
				}
				
				if (jQuery("#patCatOtherInsurance").attr('checked')) {
					if (jQuery("#exemptionNumber").val().length <= 0) {
						alert('Please enter the Exemption Number');
						return false;
					}
				}
				
				if (jQuery("#patCatMalaria").attr('checked')) {
					if (jQuery("#exemptionNumber").val().length <= 0) {
						alert('Please enter the Exemption Number');
						return false;
					}
				}
				
				if (jQuery("#patCatWaiver").attr('checked')) {
					if (jQuery("#waiverNumber").val().length <= 0) {
						alert('Please enter the Waiver Number');
						return false;
					}
				}
			}

			        //ghanshya,3-july-2013 #1962 Create validation for length of Health ID and National ID
			       //Add Validation for checking duplicate National Id and Health Id
			        PAGE.checkNationalIDPassportNumber();
		            alert("click ok to proceed");
		            abc=jQuery("#abc").val();
					def=jQuery("#def").val();
					nd=jQuery("#nId").val();
					pn=jQuery("#pNum").val();
					nId=jQuery("#nId").val();
					pNum=jQuery("#pNum").val();
					
					if(typeof nId!="undefined" || typeof pNum!="undefined"){
					if(nId=="1" && pNum=="1"){
					//document.getElementById("nationalIdValidationMessage").innerHTML="Patient already registered with this National id";
					//document.getElementById("healthIdValidationMessage").innerHTML="Patient already registered with this Health id";
                    //jQuery("#nationalIdValidationMessage").show();
                    //jQuery("#healthIdValidationMessage").show();
		            alert("Patient already registered with the same National ID and Passport Number");
					return false
		            }
		            else if(nId=="1"){
                    //document.getElementById("nationalIdValidationMessage").innerHTML="Patient already registered with this National id";
                    //jQuery("#nationalIdValidationMessage").show();
                    //jQuery("#healthIdValidationMessage").hide();
		            alert("Patient already registered with the same National ID");
                    return false;					
		            }
		            else if(pNum=="1"){
		             //document.getElementById("healthIdValidationMessage").innerHTML="Patient already registered with this Health id";
                     //jQuery("#healthIdValidationMessage").show();
                     //jQuery("#nationalIdValidationMessage").hide();
		             alert("Patient already registered with the same Passport Number");	
					 return false;
		            }
		            }
		            else{
		            alert("please try again");
		            return false;
		            }
			
			
			return true;
		}
	};

	/**
	 ** VALIDATORS
	 **/
	VALIDATORS = {

		/** VALIDATE PATIENT CATEGORY */
		
		validatePatientCategory : function() {
			if (jQuery("#patCatGeneral").attr('checked') == false
					&& jQuery("#patCatHIV").attr('checked') == false
					&& jQuery("#patCatChildLessThan5yr").attr('checked') == false
					&& jQuery("#patCatNHIF").attr('checked') == false
					&& jQuery("#patCatTB").attr('checked') == false
					&& jQuery("#patCatMother").attr('checked') == false
					&& jQuery("#patCatOtherInsurance").attr('checked') == false
					&& jQuery("#patCatMalaria").attr('checked') == false
					&& jQuery("#patCatWaiver").attr('checked') == false) {
				jQuery("#patCatGeneral").attr("checked", "checked");					
			} else {
			    if (jQuery("#patCatHIV").attr('checked')) {
					if (jQuery("#exemptionNumber").val().length <= 0) {
						alert('Please enter the Exemption Number');
						return false;
					}
				}
				
				if (jQuery("#patCatChildLessThan5yr").attr('checked')) {
					if (jQuery("#exemptionNumber").val().length <= 0) {
						alert('Please enter the Exemption Number');
						return false;
					}
				}
				
				if (jQuery("#patCatNHIF").attr('checked')) {
					if (jQuery("#exemptionNumber").val().length <= 0) {
						alert('Please enter the Exemption Number');
						return false;
					}
					
					if (jQuery("#nhifCardNumber").val().length <= 0) {
						alert('Please enter the NHIF Card Number');
						return false;
					}
				}
				
				if (jQuery("#patCatTB").attr('checked')) {
					if (jQuery("#exemptionNumber").val().length <= 0) {
						alert('Please enter the Exemption Number');
						return false;
					}
				}

				if (jQuery("#patCatMother").attr('checked')) {
					if (jQuery("#exemptionNumber").val().length <= 0) {
						alert('Please enter the Exemption Number');
						return false;
					}
				}
				
				if (jQuery("#patCatOtherInsurance").attr('checked')) {
					if (jQuery("#exemptionNumber").val().length <= 0) {
						alert('Please enter the Exemption Number');
						return false;
					}
				}
				
				if (jQuery("#patCatMalaria").attr('checked')) {
					if (jQuery("#exemptionNumber").val().length <= 0) {
						alert('Please enter the Exemption Number');
						return false;
					}
				}
				
				if (jQuery("#patCatWaiver").attr('checked')) {
					if (jQuery("#waiverNumber").val().length <= 0) {
						alert('Please enter the Waiver Number');
						return false;
					}
				}
				
				
				return true;
			  }
			},
		
		/** CHECK WHEN HIV CATEGORY IS SELECTED */
		hivCheck : function() {
			if (jQuery("#patCatHIV").is(':checked')) {
				if (jQuery("#patCatGeneral").is(":checked")) {
					jQuery("#patCatGeneral").removeAttr("checked");
				}
				
					jQuery("#patCatChildLessThan5yr").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatNHIF").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					jQuery("#nhifCardNumber").val("");
					jQuery("#nhifCardField1").hide();
				    jQuery("#nhifCardField2").hide();
				
					jQuery("#patCatTB").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					
					jQuery("#patCatMother").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatOtherInsurance").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatMalaria").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatWaiver").removeAttr("checked");
				    jQuery("#waiverNumber").val("");
					jQuery("#waiverField1").hide();
				    jQuery("#waiverField2").hide();
				    
				    jQuery("#exemptionField1").show();
				    jQuery("#exemptionField2").show();

			}
			else {
			jQuery("#exemptionNumber").val("");
			jQuery("#exemptionField1").hide();
			jQuery("#exemptionField2").hide();
			}
		},

		/** CHECK WHEN child < 5 yr CATEGORY IS SELECTED */
		childYearCheck : function() {
			if (jQuery("#patCatChildLessThan5yr").is(':checked')) {
				if (jQuery("#patCatGeneral").is(":checked")) {
					jQuery("#patCatGeneral").removeAttr("checked");
				}

					jQuery("#patCatHIV").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					
					jQuery("#patCatNHIF").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					jQuery("#nhifCardNumber").val("");
					jQuery("#nhifCardField1").hide();
				    jQuery("#nhifCardField2").hide();
				
					jQuery("#patCatTB").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					
					jQuery("#patCatMother").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatOtherInsurance").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatMalaria").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatWaiver").removeAttr("checked");
				    jQuery("#waiverNumber").val("");
					jQuery("#waiverField1").hide();
				    jQuery("#waiverField2").hide();

					if (!VALIDATORS.checkPatientAgeForChildLessThan5yr()) {
					jQuery("#patCatChildLessThan5yr").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
					jQuery("#exemptionField2").hide();
					return false;
				}
				    jQuery("#exemptionField1").show();
				    jQuery("#exemptionField2").show();
			}
			else{
			jQuery("#exemptionNumber").val("");
			jQuery("#exemptionField1").hide();
			jQuery("#exemptionField2").hide();
			}
		},
		
		/** CHECK WHEN NHIF CATEGORY IS SELECTED */
		nhifCheck : function() {
			if (jQuery("#patCatNHIF").is(':checked')) {
				if (jQuery("#patCatGeneral").is(":checked")) {
					jQuery("#patCatGeneral").removeAttr("checked");
				}
				
					jQuery("#patCatHIV").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatChildLessThan5yr").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				
					jQuery("#patCatTB").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					
					jQuery("#patCatMother").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatOtherInsurance").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatMalaria").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatWaiver").removeAttr("checked");
				    jQuery("#waiverNumber").val("");
					jQuery("#waiverField1").hide();
				    jQuery("#waiverField2").hide();
				    
				    jQuery("#exemptionField1").show();
				    jQuery("#exemptionField2").show();
				    jQuery("#nhifCardField1").show();
				    jQuery("#nhifCardField2").show();
			}
			else {
			jQuery("#exemptionNumber").val("");
			jQuery("#nhifCardNumber").val("");
			jQuery("#exemptionField1").hide();
			jQuery("#exemptionField2").hide();
			jQuery("#nhifCardField1").hide();
			jQuery("#nhifCardField2").hide();
			}
		},

		/** CHECK WHEN TV CATEGORY IS SELECTED */
		tvCheck : function() {
			if (jQuery("#patCatTB").is(':checked')) {
				if (jQuery("#patCatGeneral").is(":checked")) {
					jQuery("#patCatGeneral").removeAttr("checked");
				}
				
					jQuery("#patCatHIV").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					
					jQuery("#patCatChildLessThan5yr").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatNHIF").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					jQuery("#nhifCardNumber").val("");
					jQuery("#nhifCardField1").hide();
				    jQuery("#nhifCardField2").hide();
					
					jQuery("#patCatMother").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatOtherInsurance").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatMalaria").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatWaiver").removeAttr("checked");
				    jQuery("#waiverNumber").val("");
					jQuery("#waiverField1").hide();
				    jQuery("#waiverField2").hide();
				    
				    jQuery("#exemptionField1").show();
				    jQuery("#exemptionField2").show();
			}
			else {
			jQuery("#exemptionNumber").val("");
			jQuery("#exemptionField1").hide();
			jQuery("#exemptionField2").hide();
			}
		},
		
		/** CHECK WHEN Expectant mother CATEGORY IS SELECTED */
		motherCheck : function() {
			if (jQuery("#patCatMother").is(':checked')) {
				if (jQuery("#patCatGeneral").is(":checked")) {
					jQuery("#patCatGeneral").removeAttr("checked");
				}
				
					jQuery("#patCatHIV").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					
					jQuery("#patCatChildLessThan5yr").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatNHIF").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					jQuery("#nhifCardNumber").val("");
					jQuery("#nhifCardField1").hide();
				    jQuery("#nhifCardField2").hide();
				    
				    jQuery("#patCatTB").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatOtherInsurance").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatMalaria").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatWaiver").removeAttr("checked");
				    jQuery("#waiverNumber").val("");
					jQuery("#waiverField1").hide();
				    jQuery("#waiverField2").hide();
				    
				if (jQuery("#patientGender").val() == "M") {
					jQuery("#patCatMother").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
					jQuery("#exemptionField2").hide();
					alert("This category is only valid for female patient");
					return false;
				}
					jQuery("#exemptionField1").show();
				    jQuery("#exemptionField2").show();
			}
			else {
			jQuery("#exemptionNumber").val("");
			jQuery("#exemptionField1").hide();
			jQuery("#exemptionField2").hide();
			}

		},
		
		/** CHECK WHEN OTHER INSURANCE CATEGORY IS SELECTED */
		otherInsuranceCheck : function() {
			if (jQuery("#patCatOtherInsurance").is(':checked')) {
				if (jQuery("#patCatGeneral").is(":checked")) {
					jQuery("#patCatGeneral").removeAttr("checked");
				}
				
					jQuery("#patCatHIV").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					
					jQuery("#patCatChildLessThan5yr").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatNHIF").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					jQuery("#nhifCardNumber").val("");
					jQuery("#nhifCardField1").hide();
				    jQuery("#nhifCardField2").hide();
				    
				    jQuery("#patCatTB").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					
					jQuery("#patCatMother").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatMalaria").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatWaiver").removeAttr("checked");
				    jQuery("#waiverNumber").val("");
					jQuery("#waiverField1").hide();
				    jQuery("#waiverField2").hide();
				    
				    jQuery("#exemptionField1").show();
				    jQuery("#exemptionField2").show();
			}
			else {
			jQuery("#exemptionNumber").val("");
			jQuery("#exemptionField1").hide();
			jQuery("#exemptionField2").hide();
			}
		},
		
		/** CHECK WHEN MALARIA CATEGORY IS SELECTED */
		malariaCheck : function() {
			if (jQuery("#patCatMalaria").is(':checked')) {
				if (jQuery("#patCatGeneral").is(":checked")) {
					jQuery("#patCatGeneral").removeAttr("checked");
				}
				
					jQuery("#patCatHIV").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					
					jQuery("#patCatChildLessThan5yr").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatNHIF").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					jQuery("#nhifCardNumber").val("");
					jQuery("#nhifCardField1").hide();
				    jQuery("#nhifCardField2").hide();
				    
				    jQuery("#patCatTB").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					
					jQuery("#patCatMother").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatOtherInsurance").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatWaiver").removeAttr("checked");
				    jQuery("#waiverNumber").val("");
					jQuery("#waiverField1").hide();
				    jQuery("#waiverField2").hide();
				    
				    jQuery("#exemptionField1").show();
				    jQuery("#exemptionField2").show();
			}
			else {
			jQuery("#exemptionNumber").val("");
			jQuery("#exemptionField1").hide();
			jQuery("#exemptionField2").hide();
			}
		},
		
		/** CHECK WHEN WAIVER CASE CATEGORY IS SELECTED */
		waiverCheck : function() {
			if (jQuery("#patCatWaiver").is(':checked')) {
				if (jQuery("#patCatGeneral").is(":checked")) {
					jQuery("#patCatGeneral").removeAttr("checked");
				}
				
					jQuery("#patCatHIV").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					
					jQuery("#patCatChildLessThan5yr").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatNHIF").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					jQuery("#nhifCardNumber").val("");
					jQuery("#nhifCardField1").hide();
				    jQuery("#nhifCardField2").hide();
				    
				    jQuery("#patCatTB").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					
					jQuery("#patCatMother").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatOtherInsurance").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatMalaria").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
					jQuery("#waiverField1").show();
				    jQuery("#waiverField2").show();
			}
			else {
			jQuery("#waiverNumber").val("");
			jQuery("#waiverField1").hide();
		    jQuery("#waiverField2").hide();
			}
		},
		
		/** CHECK WHEN GENERAL CATEGORY IS SELECTED */
		generalCheck : function(obj) {
			if (jQuery("#patCatGeneral").is(':checked')) {
				
					jQuery("#patCatHIV").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					
					jQuery("#patCatChildLessThan5yr").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatNHIF").removeAttr("checked");
					jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					jQuery("#nhifCardNumber").val("");
					jQuery("#nhifCardField1").hide();
				    jQuery("#nhifCardField2").hide();
				    
				    jQuery("#patCatTB").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
					
					jQuery("#patCatMother").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatOtherInsurance").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatMalaria").removeAttr("checked");
				    jQuery("#exemptionNumber").val("");
					jQuery("#exemptionField1").hide();
				    jQuery("#exemptionField2").hide();
				    
				    jQuery("#patCatWaiver").removeAttr("checked");
				    jQuery("#waiverNumber").val("");
					jQuery("#waiverField1").hide();
				    jQuery("#waiverField2").hide();
			}
		},
		
		tempCatCheck : function () {
			if (jQuery("#mlcCase").is(':checked')) {
					jQuery("#tempCat").show();	
			}
			else {
				jQuery("#tempCat").val("");	
				jQuery("#tempCat").hide();	
			}
			return true;
		},

		
		copyaddress : function () {
			if (jQuery("#sameAddress").is(':checked')) {
				jQuery("#relativePostalAddress").val(jQuery("#patientPostalAddress").val());
				
		}
		else {		jQuery("#relativePostalAddress").val('');
		}
		},
		
		checkPatientAgeForChildLessThan5yr : function() {
			estAge = jQuery("#estimatedAge").html();
			var rest=estAge.slice(1,-6); 
			var check=estAge.slice(-5); 
			if(check=="years"){
				if (rest>5) {
					if (jQuery("#patCatChildLessThan5yr").is(':checked')) {
						alert("This category is only valid for patient under 5 years of age");
						return false;
					}
				}
			}
			return true;
		},

		/*
		 * Check patient gender
		 */
		genderCheck : function() {

			jQuery("#patientRelativeNameSection").empty();
			if (jQuery("#patientGender").val() == "M") {
				jQuery("#patientRelativeNameSection")
						.html(
								'<input type="radio" name="person.attribute.15" value="Son of" checked="checked"/> Son of');
			} else if(jQuery("#patientGender").val() == "F"){
				jQuery("#patientRelativeNameSection")
						.html(
								'<input type="radio" name="person.attribute.15" value="Daughter of"/> Daughter of <input type="radio" name="person.attribute.15" value="Wife of"/> Wife of');
			}
		}
		
	};
	
	function showOtherNationality(){
	var optionValue=jQuery("#patientNation option:selected" ).text();
	if(optionValue=="Other"){
	jQuery("#otherNationality").show();
	  }
	  else{
	  jQuery("#otherNationality").hide();
	  }
	}
	
</script>
<h3 align="center" style="color:black">Search Revisit Patient<br><br></h3>

<div id="patientSearchResult"></div>
<form id="patientRegistrationForm" method="POST">
		<div class="floatLeft">
		<table>
			<tr>
				<td valign="top">Please enter Patient's Surname/First Name/Given Name or Identifier<label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="hidden" id="surName" name="patient.surName" style='width: 152px;'>
				<div id="searchbox"></div>
				<div id="numberOfFoundPatients"></div>
				</td>
			</tr>
			
		</table>
		</div>

	</form>