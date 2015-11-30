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

<style>
.cell {
	border-top: 1px solid lightgrey;
	padding: 20px;
}

td.border {
	border-width: 1px;
	border-right: 0px;
	border-bottom: 1px;
	border-color: lightgrey;
	border-style: solid;
}

td.bottom {
	border-width: 1px;
	border-bottom: 1px;
	border-right: 0px;
	border-top: 0px;
	border-left: 0px;
	border-color: lightgrey;
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

				// Fill data into address dropdowns
				PAGE.fillOptions("#districts", {
					data : MODEL.districts
				});
				PAGE.fillOptions("#upazilas", {
					data : MODEL.upazilas[0].split(',')
				});
				
				MODEL.religions = "Religion, |"
						+ MODEL.religions;
				PAGE.fillOptions("#patientReligion", {
					data : MODEL.religions,
					delimiter : ",",
					optionDelimiter : "|"
				});
				
				MODEL.payingCategory = " , |"
						+ MODEL.payingCategory;
				PAGE.fillOptions("#payingCategory", {
					data : MODEL.payingCategory,
					delimiter : ",",
					optionDelimiter : "|"
				});
				
				MODEL.nonPayingCategory = " , |"
						+ MODEL.nonPayingCategory;
				PAGE.fillOptions("#nonPayingCategory", {
					data : MODEL.nonPayingCategory,
					delimiter : ",",
					optionDelimiter : "|"
				});
				
				MODEL.specialScheme = ", |"
						+ MODEL.specialScheme;
				PAGE.fillOptions("#specialScheme", {
					data : MODEL.specialScheme,
					delimiter : ",",
					optionDelimiter : "|"
				});
				
				MODEL.universities = " , |"
						+ MODEL.universities;
				PAGE.fillOptions("#university", {
					data : MODEL.universities,
					delimiter : ",",
					optionDelimiter : "|"
				});
				
				jQuery("#payingCategoryField").hide();
				jQuery("#nonPayingCategoryField").hide();
				jQuery("#specialSchemeCategoryField").hide();
				jQuery("#nhifNumberRow").hide();
				jQuery("#universityRow").hide();
				jQuery("#studentIdRow").hide();
				jQuery("#waiverNumberRow").hide();

				// Set value for patient information
				formValues = "patient.surName==" + MODEL.surName + "||";
				formValues += "patient.firstName==" + MODEL.firstName + "||";
				formValues += "patient.otherName==" + MODEL.otherName + "||";
				formValues += "patient.birthdate==" + MODEL.patientBirthdate
						+ "||";
				formValues += "patient.gender==" + MODEL.patientGender + "||";
				formValues += "patient.identifier==" + MODEL.patientIdentifier
						+ "||";
				formValues += "patient.gender==" + MODEL.patientGender[0]
						+ "||";
				formValues += "person.attribute.8=="
						+ MODEL.patientAttributes[8] + "||";

						formValues += "person.attribute.26=="
						+ MODEL.patientAttributes[26] + "||";
						
				formValues += "person.attribute.${personAttributeReligion.id}=="
						+ MODEL.patientAttributes[${personAttributeReligion.id}] + "||";
						
				if (!StringUtils.isBlank(MODEL.patientAttributes[${personAttributeChiefdom.id}])) {
					formValues += "person.attribute.${personAttributeChiefdom.id}=="
							+ MODEL.patientAttributes[${personAttributeChiefdom.id}] + "||";
				}
						
				formValues += "person.attribute.27=="
						+ MODEL.patientAttributes[27] + "||";
						
				if (!StringUtils.isBlank(MODEL.patientAttributes[39]) && MODEL.patientAttributes[27]=="Other") {
				formValues += "person.attribute.39=="
						+ MODEL.patientAttributes[39] + "||";
				}
				else{
				jQuery("#otherNationality").hide();
				}
								
				attributes = MODEL.patientAttributes[14];
				
				jQuery.each(attributes.split(","), function(index, value) {
					jQuery("#editPatientForm").fillForm(
							"person.attribute.14==" + value + "||");
				});			
					
					
				if (!StringUtils.isBlank(MODEL.patientAttributes[16])) {
					formValues += "person.attribute.16=="
							+ MODEL.patientAttributes[16] + "||";
				}
				
				if (!StringUtils.isBlank(MODEL.patientAttributes[20])) {
					formValues += "person.attribute.20=="
							+ MODEL.patientAttributes[20] + "||";
				}
				
				if (!StringUtils.isBlank(MODEL.patientAttributes[38])) {
					formValues += "person.attribute.38=="
							+ MODEL.patientAttributes[38] + "||";
				}
				
				if (!StringUtils.isBlank(MODEL.patientAttributes[28])) {
					formValues += "person.attribute.28=="
							+ MODEL.patientAttributes[28] + "||";
				}

				if (!StringUtils.isBlank(MODEL.patientAttributes[37])) {
					formValues += "person.attribute.37=="
							+ MODEL.patientAttributes[37] + "||";
				}
				
				if (MODEL.patientAttributes[14]=="Paying") {
				jQuery("#payingCategoryField").show();
				formValues += "person.attribute.44=="
						+ MODEL.patientAttributes[44] + "||";
				}
				
				if (MODEL.patientAttributes[14]=="Non-Paying") {
				jQuery("#nonPayingCategoryField").show();
				formValues += "person.attribute.45=="
						+ MODEL.patientAttributes[45] + "||";
			     //var selectedNonPayingCategory=jQuery("#nonPayingCategory option:checked").val();
	            //if(MODEL.nonPayingCategoryMap[selectedNonPayingCategory]==="NHIF CIVIL SERVANT"){
	            if(MODEL.patientAttributes[45]=="NHIF CIVIL SERVANT"){
	            jQuery("#nhifNumberRow").show();
	            
	            if (!StringUtils.isBlank(MODEL.patientAttributes[34])) {
					formValues += "person.attribute.34==" + MODEL.patientAttributes[34] + "||";
				}
	           
	            }
				}
				
				if (MODEL.patientAttributes[14]=="Special Schemes") {
				jQuery("#specialSchemeCategoryField").show();
				formValues += "person.attribute.46=="
						+ MODEL.patientAttributes[46] + "||";
				 //var selectedSpecialScheme=jQuery("#specialScheme option:checked").val();
	            //if(MODEL.specialSchemeMap[selectedSpecialScheme]==="STUDENT SCHEME"){
	            if(MODEL.patientAttributes[46]=="STUDENT SCHEME"){
	            jQuery("#universityRow").show();
	            formValues += "person.attribute.47=="
						+ MODEL.patientAttributes[47] + "||";
	            jQuery("#studentIdRow").show();
	            formValues += "person.attribute.42=="
							+ MODEL.patientAttributes[42] + "||";
	            }
	            //if(MODEL.specialSchemeMap[selectedSpecialScheme]==="WAIVER CASE"){
	            if(MODEL.patientAttributes[46]=="WAIVER CASE"){
	            jQuery("#waiverNumberRow").show();
	            formValues += "person.attribute.32=="
							+ MODEL.patientAttributes[32] + "||";
	            }
				}
				
				// Set value for address 
				addressParts = MODEL.patientAddress.split(',');
				formValues += "patient.address.postalAddress==" + StringUtils.trim(addressParts[0]) + "||";
				jQuery("#districts").val(StringUtils.trim(addressParts[2]));
				PAGE.changeDistrict();
				jQuery("#upazilas").val(StringUtils.trim(addressParts[1]));
				PAGE.changeUpazila();
				jQuery("#locations").val(StringUtils.trim(addressParts[3]));
				
				jQuery("#editPatientForm").fillForm(formValues);
				PAGE.checkBirthDate();
				VALIDATORS.genderCheck();
				jQuery("#editPatientForm").fillForm(
						"person.attribute.15==" + MODEL.patientAttributes[15]
								+ "||");


				// binding
				jQuery("#paying").click(function() {
					VALIDATORS.payingCheck();
				});
				jQuery("#nonPaying").click(function() {
					VALIDATORS.nonPayingCheck();
				});
				jQuery("#specialSchemes").click(function() {
					VALIDATORS.specialSchemeCheck();
				});
				jQuery("#sameAddress").click(function() {
					VALIDATORS.copyaddress();
				});

				jQuery('#calendar').datepicker({
					yearRange : 'c-100:c+100',
					dateFormat : 'dd/mm/yy',
					changeMonth : true,
					changeYear : true
				});
				jQuery('#birthdate').change(PAGE.checkBirthDate);
				
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
			fullNameInCapital = StringUtils.capitalize(jQuery("#patientName",
					jQuery("#editPatientForm")).val());
			jQuery("#patientName", jQuery("#editPatientForm")).val(
					fullNameInCapital);
			relativeNameInCaptital = StringUtils.capitalize(jQuery("#patientRelativeName").val());
			jQuery("#patientRelativeName").val(relativeNameInCaptital);

			// Validate and submit
			if (this.validateRegisterForm()) {
				jQuery("#editPatientForm")
						.mask(
								"<img src='" + openmrsContextPath + "/moduleResources/hospitalcore/ajax-loader.gif" + "'/>&nbsp;");
				jQuery("#editPatientForm").ajaxSubmit(
						{
							success : function(responseText, statusText, xhr) {
								json = jQuery.parseJSON(responseText);
								if (json.status == "success") {
									window.location.href = openmrsContextPath
											+ "/findPatient.htm";
								} else {
									alert(json.message);
								}
								jQuery("#editPatientForm").unmask();
							}
						});
			}
		},

		checkNationalID : function() {	
		nationalId=jQuery("#patientNationalId").val();
		jQuery.ajax({
		type : "GET",
		url : getContextPath() + "/module/registration/validatenationalidandpassportnumber.form",
		data : ({
			nationalId			: nationalId
				}),
		success : function(data) {	
		jQuery("#divForNationalId").html(data);
		validateNationalID();
		   } 
         });
	   },
	   
	    checkPassportNumber : function() {	
		passportNumber=jQuery("#passportNumber").val();
		jQuery.ajax({
		type : "GET",
		url : getContextPath() + "/module/registration/validatenationalidandpassportnumber.form",
		data : ({
			passportNumber			: passportNumber
				}),
		success : function(data) {	
		jQuery("#divForpassportNumber").html(data);
		validatePassportNumber();
		   } 
         });
	   },
	   
	   //This function is not used.left for future use if required
	   checkNationalIDAndPassportNumber : function() {	
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
		validateNationalIDAndPassportNumber();
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
								jQuery("#estimatedAgeInYear").val(json.ageInYear);
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
			
			selectedUpazila = jQuery("#upazilas option:checked").val();
			
			var loc=('${location}');
			var districtArr = loc.split("@");
			for (var i = 0; i < districtArr.length; i++){
			var dis = districtArr[i];
			var subcountyArr = dis.split("/");
			if(subcountyArr[0]==selectedDistrict){
			for(var j = 1; j < subcountyArr.length; j++){
			
			var locationArr = subcountyArr[j].split(".");
			
			if(locationArr[0]==selectedUpazila){
			var _locations = new Array();
			for(var k = 1; k < locationArr.length; k++){
			_locations.push(locationArr[k]);
			
			PAGE.fillOptions("#locations", {
					data : _locations
				});
			
			   }
			  }
			 }
			}
		  }	
			
		},
		
		/** CHANGE UPAZILA */
		changeUpazila : function() {
			selectedDistrict = jQuery("#districts option:checked").val();
			selectedUpazila = jQuery("#upazilas option:checked").val();
			var loc=('${location}');
			var districtArr = loc.split("@");
			for (var i = 0; i < districtArr.length; i++){
			var dis = districtArr[i];
			var subcountyArr = dis.split("/");
			if(subcountyArr[0]==selectedDistrict){
			for(var j = 1; j < subcountyArr.length; j++){
			
			var locationArr = subcountyArr[j].split(".");
			
			if(locationArr[0]==selectedUpazila){
			var _locations = new Array();
			for(var k = 1; k < locationArr.length; k++){
			_locations.push(locationArr[k]);
			
			PAGE.fillOptions("#locations", {
					data : _locations
				});
			
			   }
			  }
			 }
			}
		  }	
		},

		/** VALIDATE FORM */
		validateRegisterForm : function() {

			if (StringUtils.isBlank(jQuery("#surName").val())) {
				alert("Please enter the surname of the patient ");
				return false;
			}
			else{
			    value = jQuery("#surName").val();
				value = value.toUpperCase();
				//pattern = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -";
				pattern = "ABCDEFGHIJKLMNOPQRSTUVWXYZ -";
				for (i = 0; i < value.length; i++) {
					if (pattern.indexOf(value[i]) < 0) {
						alert("Please enter surname/identifier in correct format");
						return false;
					}
				}
			}
			
			if (StringUtils.isBlank(jQuery("#firstName").val())) {
				alert("Please enter firstname in correct format");
				return false;
			}
			else{
			    value = jQuery("#firstName").val();
				value = value.toUpperCase();
				//pattern = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -";
				pattern = "ABCDEFGHIJKLMNOPQRSTUVWXYZ -";
				for (i = 0; i < value.length; i++) {
					if (pattern.indexOf(value[i]) < 0) {
						alert("Please enter firstname in correct format");
						return false;
					}
				}
			}
			
			if (!StringUtils.isBlank(jQuery("#otherName").val())) {
			 value = jQuery("#otherName").val();
				value = value.toUpperCase();
				//pattern = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -";
				pattern = "ABCDEFGHIJKLMNOPQRSTUVWXYZ -";
				for (i = 0; i < value.length; i++) {
					if (pattern.indexOf(value[i]) < 0) {
						alert("Please enter othername in correct format");
						return false;
					}
				}
			}

			if (StringUtils.isBlank(jQuery("#patientRelativeName").val())) {
				alert("Please enter the patient's relative name");
				return false;
			}
			else{
			    value = jQuery("#patientRelativeName").val();
				//value = value.substr(0, 1).toUpperCase() + value.substr(1);
				//jQuery("#patientRelativeName").val(value);
				if(/^[a-zA-Z- ]*$/.test(value) == false) {
					alert("Please enter patient's relative name in correct format");
					return false;
				}
			}
			
			if (jQuery("#relationshipType").val() == "Relationship") {
				alert("Please enter the patient's relationship type with the NOK");
				return false;
			}
			
			if (jQuery("#relativePostalAddress").val().length>255) {
			    alert("Kin Physical Address should not exceed more than 255 characters");
				return false;
			}

			if (StringUtils.isBlank(jQuery("#birthdate").val())) {
				alert("Please enter age or DOB of the patient");
				return false;
			}

			if (jQuery("#patientGender").val() == "Any") {
				alert("Please select gender of the patient");
				return false;
			}
			else{
				var selectedPayingCategory=jQuery("#payingCategory option:checked").val();
	             if(selectedPayingCategory=="EXPECTANT MOTHER"){
	              if(jQuery("#patientGender").val() == "M"){
	              alert("Selected Payment category is only valid for Female");
	              return false;
	              }
	           }
	       } 
			
			if (jQuery("#patientGender").val() == "M" &&  jQuery("#patientMaritalStatus").val() == "Widow") {
				alert("Widow marital status is only for Female");
				return false;
			}		

			if (jQuery("#patientGender").val() == "F" &&  jQuery("#patientMaritalStatus").val() == "Widower") {
				alert("Widower marital status is only for Male");
				return false;
			}
			
		/*	if (jQuery("#patientMaritalStatus").val() == "Marital") {
				alert("Please select marital status of the patient");
				return false;
			} 
			
			if (jQuery("#patientReligion").val() == "Religion") {
				alert("Please select religion of the patient");
				return false;
			} 
			*/
			if (StringUtils.isBlank(jQuery("#patientPostalAddress").val())) {
				alert("Please enter the physical address of the patient");
				return false;
			} 
			else{
			if (jQuery("#patientPostalAddress").val().length>255) {
			    alert("Physical Address should not exceed more than 255 characters");
				return false;
			  }
			}

			if (!StringUtils.isBlank(jQuery("#patientPhoneNumber").val())) {
				if (!StringUtils.isDigit(jQuery("#patientPhoneNumber").val())) {
					alert("Please enter the patient's contact number in correct format");
					return false;
				}
			}
			
			if (!StringUtils.isBlank(jQuery("#patientEmail").val())) {
			var x=jQuery("#patientEmail").val();
			//var regExpForEmail = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
			var regExpForEmail = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
			if (regExpForEmail.test(x)) {
			return true;
			}
			else {
			alert("Please enter the patient's e-mail address in correct format");
			return false;
			}
			
			}
		
			if (jQuery("#paying").attr('checked') == false
					&& jQuery("#nonPaying").attr('checked') == false
					&& jQuery("#specialSchemes").attr('checked') == false) {			
			    alert("You did not choose any of the payment categories");
				return false;
			} 
			else {
			    if (jQuery("#paying").attr('checked')) {
					if (StringUtils.isBlank(jQuery("#payingCategory").val())){
						alert("Please select the Paying Category");
						return false;
					}
					else{
					var selectedPayingCategory=jQuery("#payingCategory option:checked").val();
	                var estAge = jQuery("#estimatedAgeInYear").val();
	                if(selectedPayingCategory=="CHILD LESS THAN 5 YEARS"){
	                if(estAge<6){
	 
	                }
	                else{
	                alert("Selected Payment category is only valid for a child less than 5 years");
	                return false;
	                }
	               }
	              }
				}
			    else if (jQuery("#nonPaying").attr('checked')) {
					if (StringUtils.isBlank(jQuery("#nonPayingCategory").val())){
						alert("Please select the Non-Paying Category");
						return false;
					}
					else{
					     var selectedNonPayingCategory=jQuery("#nonPayingCategory option:checked").val();
	                     //if(MODEL.nonPayingCategoryMap[selectedNonPayingCategory]=="NHIF CIVIL SERVANT"){
	                     if(selectedNonPayingCategory=="NHIF CIVIL SERVANT"){
	                          if (StringUtils.isBlank(jQuery("#nhifNumber").val())){
						      alert("Please enter the NHIF Number");
						      return false;
					           }
	                       }
					   }
				}
				else if (jQuery("#specialSchemes").attr('checked')) {
					if (StringUtils.isBlank(jQuery("#specialScheme").val())){
						alert("Please select the Special Scheme");
						return false;
					}
					else{
					     var selectedSpecialScheme=jQuery("#specialScheme option:checked").val();
	                     //if(MODEL.specialSchemeMap[selectedSpecialScheme]=="STUDENT SCHEME"){
	                     if(selectedSpecialScheme=="STUDENT SCHEME"){
	                          if (StringUtils.isBlank(jQuery("#university").val())){
						      alert("Please select the University");
						      return false;
					          }
	                          if (StringUtils.isBlank(jQuery("#studentId").val())){
						      alert("Please enter the Student ID");
						      return false;
					           }
	                      }
	                     //if(MODEL.specialSchemeMap[selectedSpecialScheme]=="WAIVER CASE"){
	                     if(selectedSpecialScheme=="WAIVER CASE"){
	                          if (StringUtils.isBlank(jQuery("#waiverNumber").val())){
						      alert("Please enter the Waiver Number");
						      return false;
					           }
	                      }
					   }
				}
			}
			
			//submitNationalIDAndPassportNumber();
            if(validateNationalIDAndPassportNumber()){
            return true;
            }
            else{
            return false;
            }

			return true;
		}
	};

	/**
	 ** VALIDATORS
	 **/
	 VALIDATORS = {

	/** CHECK WHEN PAYING CATEGORY IS SELECTED */
       payingCheck : function() {
			if (jQuery("#paying").is(':checked')) {
					jQuery("#nonPaying").removeAttr("checked");
					jQuery("#payingCategoryField").show();
				    jQuery("#nonPayingCategoryField").hide();
				    jQuery("#specialSchemeCategoryField").hide();
				    jQuery("#specialSchemes").removeAttr("checked");
					
					jQuery("#nhifNumberRow").hide();
					jQuery("#universityRow").hide();
	                jQuery("#studentIdRow").hide();
	                jQuery("#waiverNumberRow").hide();
			}
			else{
			jQuery("#payingCategoryField").hide();
			}
		},
		
		/** CHECK WHEN NONPAYING CATEGORY IS SELECTED */
		nonPayingCheck : function() {
			if (jQuery("#nonPaying").is(':checked')) {
					jQuery("#paying").removeAttr("checked");
				    jQuery("#nonPayingCategoryField").show();
				    jQuery("#specialSchemes").removeAttr("checked");
				    jQuery("#payingCategoryField").hide();
				    jQuery("#specialSchemeCategoryField").hide();
					
					var selectedNonPayingCategory=jQuery("#nonPayingCategory option:checked").val();
	                //if(MODEL.nonPayingCategoryMap[selectedNonPayingCategory]==="NHIF CIVIL SERVANT"){
	                if(selectedNonPayingCategory=="NHIF CIVIL SERVANT"){
	                jQuery("#nhifNumberRow").show();
	                }
	                else{
	                jQuery("#nhifNumberRow").hide();
	                }
	                
					jQuery("#universityRow").hide();
	                jQuery("#studentIdRow").hide();
	                jQuery("#waiverNumberRow").hide();
			}
			else{
			jQuery("#nonPayingCategoryField").hide();
			jQuery("#nhifNumberRow").hide();
			}
		},
		
		/** CHECK WHEN SPECIAL SCHEME CATEGORY IS SELECTED */
		specialSchemeCheck : function() {
			if (jQuery("#specialSchemes").is(':checked')) {
					jQuery("#paying").removeAttr("checked");
					jQuery("#payingCategoryField").hide();
					jQuery("#nonPayingCategoryField").hide();
					jQuery("#nonPaying").removeAttr("checked");
					jQuery("#specialSchemeCategoryField").show();
					
					jQuery("#nhifNumberRow").hide();
					
					var selectedSpecialScheme=jQuery("#specialScheme option:checked").val();
	                //if(MODEL.specialSchemeMap[selectedSpecialScheme]=="STUDENT SCHEME"){
	                if(selectedSpecialScheme=="STUDENT SCHEME"){
	                jQuery("#universityRow").show();
	                jQuery("#studentIdRow").show();
	                }
	                else{
	                jQuery("#universityRow").hide();
	                jQuery("#studentIdRow").hide();
	                }
	                
	                //if(MODEL.specialSchemeMap[selectedSpecialScheme]=="WAIVER CASE"){
	                if(selectedSpecialScheme=="WAIVER CASE"){
	                jQuery("#waiverNumberRow").show();
	                }
	                else{
	                jQuery("#waiverNumberRow").hide();
	                }				
			}
			else{
			jQuery("#specialSchemeCategoryField").hide();
			jQuery("#universityRow").hide();
	        jQuery("#studentIdRow").hide();
	        jQuery("#waiverNumberRow").hide();
			}
		},
		
		copyaddress : function () {
			if (jQuery("#sameAddress").is(':checked')) {
				jQuery("#relativePostalAddress").val(jQuery("#patientPostalAddress").val());
		}
		else {	jQuery("#relativePostalAddress").val('');
		}
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
				},
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
	
	function submitNationalID(){
	PAGE.checkNationalID();
   }
	
	function validateNationalID(){
	var nId=jQuery("#nId").val();
	if(nId=="1"){
	document.getElementById("nationalIdValidationMessage").innerHTML="Patient already registered with this National ID";
	jQuery("#nationalIdValidationMessage").show();
    return false;					
    }
    else{
    jQuery("#nationalIdValidationMessage").hide();
    }  
   }
		          
		       
   function submitPassportNumber(){
   PAGE.checkPassportNumber();
   }
   
   function validatePassportNumber(){
   var pNum=jQuery("#pNum").val();
   if(pNum=="1"){
   document.getElementById("passportNumberValidationMessage").innerHTML="Patient already registered with this Passport Number";
   jQuery("#passportNumberValidationMessage").show();
   return false;
	}
	else{
	jQuery("#passportNumberValidationMessage").hide();
	}
   }
   
   function submitNationalIDAndPassportNumber(){
   PAGE.checkNationalIDAndPassportNumber();
   }
   
   function validateNationalIDAndPassportNumber(){
   var nId=jQuery("#nId").val();
   var pNum=jQuery("#pNum").val();
   if(nId=="1" && pNum=="1"){
   //alert("Patient already registered with the same National ID and Passport Number");	
   document.getElementById("nationalIdValidationMessage").innerHTML="Patient already registered with this National ID";
   document.getElementById("passportNumberValidationMessage").innerHTML="Patient already registered with this Passport Number";
   jQuery("#nationalIdValidationMessage").show();
   jQuery("#passportNumberValidationMessage").show();
   return false;
	}
   else if(nId=="1"){
   //alert("Patient already registered with the same National ID");
   document.getElementById("nationalIdValidationMessage").innerHTML="Patient already registered with this National ID";
   jQuery("#nationalIdValidationMessage").show();
   jQuery("#passportNumberValidationMessage").hide();
   return false;					
    }  
   else if(pNum=="1"){
   //alert("Patient already registered with the same Passport Number");	
   jQuery("#nationalIdValidationMessage").hide();
   jQuery("#passportNumberValidationMessage").show();
   return false;
	}
   else{
   jQuery("#nationalIdValidationMessage").hide();
   jQuery("#passportNumberValidationMessage").hide();
   return true;
	}
   }
	
    
    function payingCategorySelection(){
	var selectedPayingCategory=jQuery("#payingCategory option:checked").val();
	 var estAge = jQuery("#estimatedAgeInYear").val();
	 if(selectedPayingCategory=="CHILD LESS THAN 5 YEARS"){
	 if(estAge<6){

	 }
	 else{
	 alert("This category is only valid for a child less than 5 years");
	 return false;
	 }
	 }
	 else{
	  if(selectedPayingCategory=="EXPECTANT MOTHER"){
	  if (jQuery("#patientGender").val() == "M"){
	  alert("This category is only valid for female");
	  }
	  }
	 }
	}
    
    function nonPayingCategorySelection(){
	var selectedNonPayingCategory=jQuery("#nonPayingCategory option:checked").val();
	//if(MODEL.nonPayingCategoryMap[selectedNonPayingCategory]=="NHIF CIVIL SERVANT"){
	if(selectedNonPayingCategory=="NHIF CIVIL SERVANT"){
	jQuery("#nhifNumberRow").show();
	}
	else{
	jQuery("#nhifNumberRow").hide();
	}
	}
	
	function specialSchemeSelection(){
	var selectedSpecialScheme=jQuery("#specialScheme option:checked").val();
	//if(MODEL.specialSchemeMap[selectedSpecialScheme]=="STUDENT SCHEME"){
	if(selectedSpecialScheme=="STUDENT SCHEME"){
	jQuery("#universityRow").show();
	jQuery("#studentIdRow").show();
	}
	else{
	jQuery("#universityRow").hide();
	jQuery("#studentIdRow").hide();
	}
	  
	//if(MODEL.specialSchemeMap[selectedSpecialScheme]=="WAIVER CASE"){
	if(selectedSpecialScheme=="WAIVER CASE"){
	jQuery("#waiverNumberRow").show();
	}
	else{
	jQuery("#waiverNumberRow").hide();
	}
	
	}
</script>
<h3 align="center" style="color:black">EDIT PATIENT INFORMATION<br></h3>
<form id="editPatientForm" method="POST">
		<table width="100%">
		<tr>
		<td width="48%" align="right"><b>Patient Identifier</b><label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td><b><input readonly name="patient.identifier" style="border: none; width: 250px; background-color:white; font-weight:bold" /></b></td>
		</tr>
		<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
		</table>
		
		<div class="floatLeft">
		<table>
			<tr>
				<td valign="top"><b>Patient Name</b><label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td valign="top">Surname<label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="text" id="surName" name="patient.surName" style='width: 152px; 	border-width: 1px;
	border-right: 1px;
	border-left: 1px;
	border-top: 1px;
	border-bottom: 1px;
	border-color: black;
	border-style: solid;'>
				</td>
			</tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>First Name<label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="text" id="firstName" name="patient.firstName" style='width: 152px; 	border-width: 1px;
	border-right: 1px;
	border-left: 1px;
	border-top: 1px;
	border-bottom: 1px;
	border-color: black;
	border-style: solid;'>
				</td>
			</tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>Other Name&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="text" id="otherName" name="patient.otherName" style='width: 152px;	border-width: 1px;
	border-right: 1px;
	border-left: 1px;
	border-top: 1px;
	border-bottom: 1px;
	border-color: black;
	border-style: solid;'>
				</td>
			</tr>
			<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
			<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
			<tr>
				<td><b>Demographics</b><label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>Age or DOB<label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="hidden" id="calendar" /> <input
							id="birthdate" name="patient.birthdate" style='width: 152px;'/> <img
							id="calendarButton"
							src="moduleResources/registration/calendar.gif" /> <input
							id="birthdateEstimated" type="hidden"
							name="patient.birthdateEstimate" value="true" />
							<input type="hidden" id="estimatedAgeInYear" name="estimatedAgeInYear"/>
							<span id="estimatedAge" />
				</td>
			</tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>Gender<label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><select id="patientGender" name="patient.gender" style='width: 152px;'>
								<option value="Any"></option>
								<option value="M">Male</option>
								<option value="F">Female</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>Marital Status</td>
				<td><select id="maritalStatus" name="person.attribute.26" style='width: 152px;'>
										<option value="Marital"></option>
										<option value="Single">Single</option>
										<option value="Married">Married</option>
										<option value="Divorced">Divorced</option>
										<option value="Widow">Widow</option>
										<option value="Widower">Widower</option>
										<option value="Separated">Separated</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>Religion</td>
				<td><select id="patientReligion" name="person.attribute.${personAttributeReligion.id}" style='width: 152px;'>	
					</select>
				</td>
			</tr>
			<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
			<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>

			<tr>
				<td><b>Address</b><label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>Physical Address<label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input id="patientPostalAddress" name="patient.address.postalAddress" style='width: 152px;' />
				</td>
			</tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>County&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><select id="districts" name="patient.address.district"
							onChange="PAGE.changeDistrict();" style="width: 152px;">
						</select>
				</td>
			</tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>Sub-county&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><select id="upazilas" name="patient.address.upazila"
							onChange="PAGE.changeUpazila();" style="width: 152px;">
						</select>
				</td>
			</tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>Location&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><select id="locations" name="patient.address.location"
							style="width: 152px;">
						</select>
				</td>
			</tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>Chiefdom&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input id="chiefdom" name="person.attribute.${personAttributeChiefdom.id}"
				           style='width: 152px;' />
				</td>
			</tr>
			<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
			<tr>
				<td><b>Contact Number&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input id="patientPhoneNumber"
				name="person.attribute.16" style='width: 152px;' />
				</td>
			</tr>
			<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
			<tr>
				<td><b>E-mail Address&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input id="patientEmail"
				name="person.attribute.37" style='width: 152px;' />
				</td>
			</tr>
			<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
			
			<tr>
				<td><b>Nationality&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><select id="patientNation" name="person.attribute.27" style="width: 152px;" onchange="showOtherNationality();">
										<option value="Kenya">Kenya</option>
										<option value="East Africa">East Africa</option>
										<option value="Kenyan">Africa</option>
										<option value="Algeria">Algeria</option>
										<option value="Angola">Angola</option>
										<option value="Benin">Benin</option>
										<option value="Botswana">Botswana</option>
										<option value="Burkina Faso">Burkina Faso</option>
										<option value="Burundi">Burundi</option>
										<option value="Cameroon">Cameroon</option>
										<option value="Cape Verde">Cape Verde</option>
										<option value="Central African Republic">Central African Republic</option>
										<option value="Chad">Chad</option>
										<option value="Comoros">Comoros</option>
										<option value="Cote d'Ivoire">Cote d'Ivoire</option>
										<option value="Democratic Republic of Congo">Democratic Republic of Congo</option>
										<option value="Djibouti">Djibouti</option>
										<option value="Egypt">Egypt</option>
										<option value="Equatorial Guinea">Equatorial Guinea</option>
										<option value="Eritrea">Eritrea</option>
										<option value="Ethiopia">Ethiopia</option>
										<option value="Gabon">Gabon</option>
										<option value="Gambia">Gambia</option>
										<option value="Ghana">Ghana</option>
										<option value="Guinea">Guinea</option>
										<option value="Guinea-Bissau">Guinea-Bissau</option>
										<option value="Lesotho">Lesotho</option>
										<option value="Liberia">Liberia</option>
										<option value="Libya">Libya</option>
										<option value="Madagascar">Madagascar</option>
										<option value="Malawi">Malawi</option>
										<option value="Mali">Mali</option>
										<option value="Mauritania">Mauritania</option>
										<option value="Mauritius">Mauritius</option>
										<option value="Morocco">Morocco</option>
										<option value="Mozambique">Mozambique</option>
										<option value="Namibia">Namibia</option>
										<option value="Niger">Niger</option>
										<option value="Nigeria">Nigeria</option>
										<option value="Republic of Congo">Republic of Congo</option>
										<option value="Rwanda">Rwanda</option>
										<option value="Sao Tome and Principe">Sao Tome and Principe</option>
										<option value="Senegal">Senegal</option>
										<option value="Seychelles">Seychelles</option>
										<option value="Sierra Leone">Sierra Leone</option>
										<option value="Somalia">Somalia</option>
										<option value="South Africa">South Africa</option>
										<option value="South Sudan">South Sudan</option>
										<option value="Sudan">Sudan</option>
										<option value="Swaziland">Swaziland</option>
										<option value="Tanzania">Tanzania</option>
										<option value="Togo">Togo</option>
										<option value="Tunisia">Tunisia</option>
										<option value="Uganda">Uganda</option>
										<option value="Zambia">Zambia</option>
										<option value="Zimbabwe">Zimbabwe</option>
										<option value="Other">Other</option>
						</select>&nbsp;&nbsp;&nbsp;&nbsp;<span id="otherNationality"><input id="otherNationalityId" name="person.attribute.39" placeholder="If others,please specify" style='width: 152px;'/></span></td>
		</tr>
		
		<tr></tr> <tr></tr><tr></tr><tr></tr><tr></tr>
		
		<tr>
				<td><b>ID Proof Details&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
				<td>National ID&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input id="patientNationalId" name="person.attribute.20" onblur="submitNationalID();" style='width: 152px;'/></td>
				<td><span style="color: red;" id="nationalIdValidationMessage"> </span></td>
		</tr>
		<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>Passport Number&nbsp;&nbsp;&nbsp;&nbsp;</td>
		        <td><input id="passportNumber" name="person.attribute.38" onblur="submitPassportNumber();" style='width: 152px;'/></td>
		        <td><span style="color: red;" id="passportNumberValidationMessage"> </span></td>
		</tr>
		</table>
		</div>
		
		<div class="floatRight">
		<table>
		<tr>
				<td><b>Payment Category<label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
				<td><input id="paying" type="checkbox" name="person.attribute.14" value="Paying" /> Paying</td>
				<td><span id="payingCategoryField"><select id="payingCategory" name="person.attribute.44" onchange="payingCategorySelection();" style='width: 152px;'>	</select></span></td>
		</tr>
		<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
				<td><input id="nonPaying" type="checkbox" name="person.attribute.14" value="Non-Paying" /> Non-Paying</td>
				<td><span id="nonPayingCategoryField"><select id="nonPayingCategory" name="person.attribute.45" onchange="nonPayingCategorySelection();" style='width: 152px;'>	</select></span></td>
		</tr>
		<tr id="nhifNumberRow">
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="text" id="nhifNumber" name="person.attribute.34" placeholder="NHIF NUMBER" style='width: 152px; 	border-width: 1px;
	border-right: 1px;
	border-left: 1px;
	border-top: 1px;
	border-bottom: 1px;
	border-color: black;
	border-style: solid;'></td>
		</tr>
		<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input id="specialSchemes" type="checkbox" name="person.attribute.14" value="Special Schemes" /> Special Schemes</td>
				<!--
				<td><span id="specialSchemeField"><input id="specialSchemeName" name="person.attribute.42" placeholder="Please specify" style='width: 152px;'/></span></td>
				-->
				<td><span id="specialSchemeCategoryField"><select id="specialScheme" name="person.attribute.46" onchange="specialSchemeSelection();" style='width: 152px;'>	</select></span></td>
		</tr>
		<tr id="universityRow">
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><span id="universityField"><select id="university" name="person.attribute.47" style='width: 152px;'>	</select></span></td>
		</tr>
		<tr id="studentIdRow">
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="text" id="studentId" name="person.attribute.42" placeholder="StudentID" style='width: 152px; 	border-width: 1px;
	border-right: 1px;
	border-left: 1px;
	border-top: 1px;
	border-bottom: 1px;
	border-color: black;
	border-style: solid;'></td>
		</tr>
	  <tr id="waiverNumberRow">
			<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td><input type="text" id="waiverNumber" name="person.attribute.32" placeholder="Waiver Number" style='width: 152px; 	border-width: 1px;
	border-right: 1px;
	border-left: 1px;
	border-top: 1px;
	border-bottom: 1px;
	border-color: black;
	border-style: solid;'></td>
		</tr>
		<!--
		<tr></tr><tr></tr>
		<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><span id="fileNumberField"><input id="fileNumber" name="person.attribute.43" placeholder="File Number" style='width: 152px;'/></span></td>
		</tr>
		-->
		<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
		
		<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><b>Next of Kin Details&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
		</tr>
		<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
		<tr>
				<td><b>Next of Kin&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
				<td>Relative Name<label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input id="patientRelativeName" name="person.attribute.8" style='width: 152px;' />
				</td>
			</tr>
			<tr>
				<td><b>Information</b><label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>Relationship<label style="color:red">*</label>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><select id="relationshipType" name="person.attribute.15" style='width: 152px;'>
										<option value="Relationship"></option>
										<option value="Parent">Parent</option>
										<option value="Spouse">Spouse</option>
										<option value="Guardian">Guardian</option>
										<option value="Friend">Friend</option>
										<option value="Other">Other</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>Physical Address&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="text" id="relativePostalAddress" name="person.attribute.28" style='width: 152px; 	border-width: 1px;
	border-right: 1px;
	border-left: 1px;
	border-top: 1px;
	border-bottom: 1px;
	border-color: black;
	border-style: solid;
'/>
				<input id="sameAddress" type="checkbox"/> Same as above
				</td>
			</tr>
		</table>
		</div>
		
		<div id="divForNationalId"></div>
		<div id="divForpassportNumber"></div>
		
		<div class="floatBottom">
		<table width="100%" height="100%">
		<tr valign="bottom">
		<td valign="bottom"><input type="button" value="Save" onclick="PAGE.submit();" style="font-weight:bold"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		                    <!--
		                    <input type="button" value="Reset" onclick="window.location.href=window.location.href" style="font-weight:bold"/>
		                    -->
		</td>
		</tr>
		</table>
		</div>

	</form>