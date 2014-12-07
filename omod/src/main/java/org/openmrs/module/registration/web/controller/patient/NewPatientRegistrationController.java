/**
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
 **/

package org.openmrs.module.registration.web.controller.patient;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.Date;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.dom4j.DocumentException;
import org.jaxen.JaxenException;
import org.openmrs.Concept;
import org.openmrs.Encounter;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.PatientIdentifier;
import org.openmrs.PersonAttribute;
import org.openmrs.PersonAttributeType;
import org.openmrs.PersonName;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.util.GlobalPropertyUtil;
import org.openmrs.module.hospitalcore.util.HospitalCoreConstants;
import org.openmrs.module.hospitalcore.util.HospitalCoreUtils;
import org.openmrs.module.registration.RegistrationService;
import org.openmrs.module.registration.includable.validator.attribute.PatientAttributeValidatorService;
import org.openmrs.module.registration.model.RegistrationFee;
import org.openmrs.module.registration.util.RegistrationConstants;
import org.openmrs.module.registration.util.RegistrationUtils;
import org.openmrs.module.registration.web.controller.util.RegistrationWebUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller("NewPatientRegistrationController")
@RequestMapping("/newPatientRegistration.htm")
public class NewPatientRegistrationController {

	private static Log logger = LogFactory
			.getLog(NewPatientRegistrationController.class);

	@RequestMapping(method = RequestMethod.GET)
	public String showForm(HttpServletRequest request, Model model)
			throws JaxenException, DocumentException, IOException {
		HospitalCoreService hospitalCoreService = (HospitalCoreService) Context.getService(HospitalCoreService.class);
		model.addAttribute("patientIdentifier",
				RegistrationUtils.getNewIdentifier());
		model.addAttribute(
				"referralHospitals",
				RegistrationWebUtils
						.getSubConcepts(RegistrationConstants.CONCEPT_NAME_PATIENT_REFERRED_FROM));
		model.addAttribute(
				"referralReasons",
				RegistrationWebUtils
						.getSubConcepts(RegistrationConstants.CONCEPT_NAME_REASON_FOR_REFERRAL));
		RegistrationWebUtils.getAddressDta(model);
		model.addAttribute(
				"TEMPORARYCAT",
				RegistrationWebUtils
						.getSubConcepts(RegistrationConstants.CONCEPT_NAME_MEDICO_LEGAL_CASE));
		model.addAttribute("religionList", RegistrationWebUtils.getReligionConcept());
		PersonAttributeType personAttributeReligion=hospitalCoreService.getPersonAttributeTypeByName("Religion");
		model.addAttribute("personAttributeReligion", personAttributeReligion);
		PersonAttributeType personAttributeChiefdom=hospitalCoreService.getPersonAttributeTypeByName("Chiefdom");
		model.addAttribute("personAttributeChiefdom", personAttributeChiefdom);
		model.addAttribute("TRIAGE", RegistrationWebUtils
				.getSubConcepts(RegistrationConstants.CONCEPT_NAME_TRIAGE));
		model.addAttribute(
				"OPDs",
				RegistrationWebUtils
						.getSubConcepts(RegistrationConstants.CONCEPT_NAME_OPD_WARD));
		model.addAttribute(
				"SPECIALCLINIC",
				RegistrationWebUtils
						.getSubConcepts(RegistrationConstants.CONCEPT_NAME_SPECIAL_CLINIC));
		model.addAttribute("initialRegFee", GlobalPropertyUtil.getString(RegistrationConstants.PROPERTY_INITIAL_REGISTRATION_FEE, ""));
		
			return "/module/registration/patient/newPatientRegistration";

	}

	@RequestMapping(method = RequestMethod.POST)
	public String savePatient(HttpServletRequest request, Model model)
			throws IOException {

		// list all parameter submitted
		Map<String, String> parameters = RegistrationWebUtils
				.optimizeParameters(request);
		logger.info("Submited parameters: " + parameters);

		Patient patient;
		try {
			// create patient
			patient = generatePatient(parameters);
			patient = Context.getPatientService().savePatient(patient);
			RegistrationUtils.savePatientSearch(patient);
			logger.info(String.format("Saved new patient [id=%s]",
					patient.getId()));

			// create encounter for the visit
			Encounter encounter = createEncounter(patient, parameters);
			encounter = Context.getEncounterService().saveEncounter(encounter);
			logger.info(String
					.format("Saved encounter for the visit of patient [id=%s, patient=%s]",
							encounter.getId(), patient.getId()));
			model.addAttribute("status", "success");
			model.addAttribute("patientId", patient.getPatientId());
			model.addAttribute("encounterId", encounter.getId());
		} catch (Exception e) {

			e.printStackTrace();
			model.addAttribute("status", "error");
			model.addAttribute("message", e.getMessage());
		}
		return "/module/registration/patient/savePatient";
	}

	/**
	 * Generate Patient From Parameters
	 * 
	 * @param parameters
	 * @return
	 * @throws Exception
	 */
	private Patient generatePatient(Map<String, String> parameters)
			throws Exception {

		Patient patient = new Patient();

		// get person name
		if (!StringUtils.isBlank(parameters
				.get(RegistrationConstants.FORM_FIELD_PATIENT_SURNAME))
				&& !StringUtils
						.isBlank(parameters
								.get(RegistrationConstants.FORM_FIELD_PATIENT_FIRSTNAME))) {
			PersonName personName = RegistrationUtils
					.getPersonName(
							null,
							parameters
									.get(RegistrationConstants.FORM_FIELD_PATIENT_SURNAME),
							parameters
									.get(RegistrationConstants.FORM_FIELD_PATIENT_FIRSTNAME),
							parameters
									.get(RegistrationConstants.FORM_FIELD_PATIENT_OTHERNAME));
			patient.addName(personName);
		}

		// get identifier
		if (!StringUtils.isBlank(parameters
				.get(RegistrationConstants.FORM_FIELD_PATIENT_IDENTIFIER))) {
			PatientIdentifier identifier = RegistrationUtils
					.getPatientIdentifier(parameters
							.get(RegistrationConstants.FORM_FIELD_PATIENT_IDENTIFIER));
			patient.addIdentifier(identifier);
		}

		// get birthdate
		if (!StringUtils.isBlank(parameters
				.get(RegistrationConstants.FORM_FIELD_PATIENT_BIRTHDATE))) {
			patient.setBirthdate(RegistrationUtils.parseDate(parameters
					.get(RegistrationConstants.FORM_FIELD_PATIENT_BIRTHDATE)));
			if (parameters
					.get(RegistrationConstants.FORM_FIELD_PATIENT_BIRTHDATE_ESTIMATED)
					.contains("true")) {
				patient.setBirthdateEstimated(true);
			}
		}

		// get gender
		if (!StringUtils.isBlank(parameters
				.get(RegistrationConstants.FORM_FIELD_PATIENT_GENDER))) {
			patient.setGender(parameters
					.get(RegistrationConstants.FORM_FIELD_PATIENT_GENDER));
		}

		// get address
		if (!StringUtils
				.isBlank(parameters
						.get(RegistrationConstants.FORM_FIELD_PATIENT_ADDRESS_DISTRICT))) {
			patient.addAddress(RegistrationUtils.getPersonAddress(
					null,
					parameters
							.get(RegistrationConstants.FORM_FIELD_PATIENT_ADDRESS_POSTALADDRESS),
					parameters
							.get(RegistrationConstants.FORM_FIELD_PATIENT_ADDRESS_DISTRICT),
					parameters
							.get(RegistrationConstants.FORM_FIELD_PATIENT_ADDRESS_UPAZILA),
							parameters
							.get(RegistrationConstants.FORM_FIELD_PATIENT_ADDRESS_LOCATION)));
		}

		// get custom person attribute
		PatientAttributeValidatorService validator = new PatientAttributeValidatorService();
		Map<String, Object> validationParameters = HospitalCoreUtils
				.buildParameters("patient", patient, "attributes", parameters);
		String validateResult = validator.validate(validationParameters);
		logger.info("Attirubte validation: " + validateResult);
		if (StringUtils.isBlank(validateResult)) {
			for (String name : parameters.keySet()) {
				if ((name.contains(".attribute."))
						&& (!StringUtils.isBlank(parameters.get(name)))) {
					String[] parts = name.split("\\.");
					String idText = parts[parts.length - 1];
					Integer id = Integer.parseInt(idText);
					PersonAttribute attribute = RegistrationUtils
							.getPersonAttribute(id, parameters.get(name));
					patient.addAttribute(attribute);
				}
			}
		} else {
			throw new Exception(validateResult);
		}

		return patient;
	}

	/**
	 * Create Encouunter For The Visit Of Patient
	 * 
	 * @param patient
	 * @param parameters
	 * @return
	 */
	private Encounter createEncounter(Patient patient,
			Map<String, String> parameters) {

		Encounter encounter = RegistrationWebUtils.createEncounter(patient,
				false);

		if (!StringUtils.isBlank(parameters
				.get(RegistrationConstants.FORM_FIELD_PATIENT_TRIAGE))) {
			Concept triageConcept = Context.getConceptService().getConcept(
					RegistrationConstants.CONCEPT_NAME_TRIAGE);

			Concept selectedTRIAGEConcept = Context
					.getConceptService()
					.getConcept(
							parameters
									.get(RegistrationConstants.FORM_FIELD_PATIENT_TRIAGE));
			String selectedCategory=parameters.get(RegistrationConstants.FORM_FIELD_PAYMENT_CATEGORY);
			Obs triageObs = new Obs();
			triageObs.setConcept(triageConcept);
			triageObs.setValueCoded(selectedTRIAGEConcept);
			encounter.addObs(triageObs);

			RegistrationWebUtils.sendPatientToTriageQueue(patient,
					selectedTRIAGEConcept, false, selectedCategory);
		} else if (!StringUtils.isBlank(parameters
				.get(RegistrationConstants.FORM_FIELD_PATIENT_OPD_WARD))) {
			Concept opdConcept = Context.getConceptService().getConcept(
					RegistrationConstants.CONCEPT_NAME_OPD_WARD);

			Concept selectedOPDConcept = Context
					.getConceptService()
					.getConcept(
							parameters
									.get(RegistrationConstants.FORM_FIELD_PATIENT_OPD_WARD));
			String selectedCategory=parameters.get(RegistrationConstants.FORM_FIELD_PAYMENT_CATEGORY);
			Obs opdObs = new Obs();
			opdObs.setConcept(opdConcept);
			opdObs.setValueCoded(selectedOPDConcept);
			encounter.addObs(opdObs);

			RegistrationWebUtils.sendPatientToOPDQueue(patient,
					selectedOPDConcept, false, selectedCategory);
		}else {
			Concept specialClinicConcept = Context.getConceptService().getConcept(
					RegistrationConstants.CONCEPT_NAME_SPECIAL_CLINIC);

			Concept selectedSpecialClinicConcept = Context
					.getConceptService()
					.getConcept(
							parameters
									.get(RegistrationConstants.FORM_FIELD_PATIENT_SPECIAL_CLINIC));
			String selectedCategory=parameters.get(RegistrationConstants.FORM_FIELD_PAYMENT_CATEGORY);
			Obs opdObs = new Obs();
			opdObs.setConcept(specialClinicConcept);
			opdObs.setValueCoded(selectedSpecialClinicConcept);
			encounter.addObs(opdObs);

			RegistrationWebUtils.sendPatientToOPDQueue(patient,
					selectedSpecialClinicConcept, false, selectedCategory);
		}
		
		//payment category and registration fee
		Concept cnrf = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_REGISTRATION_FEE);
		Concept cnp = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NEW_PATIENT);
		Obs obsn = new Obs();
		obsn.setConcept(cnrf);
		obsn.setValueCoded(cnp);
		Double doubleVal = Double.parseDouble(parameters
				.get(RegistrationConstants.FORM_FIELD_REGISTRATION_FEE));
		obsn.setValueNumeric(doubleVal);
		obsn.setValueText(parameters
				.get(RegistrationConstants.FORM_FIELD_PAYMENT_CATEGORY));
		encounter.addObs(obsn);	

		
		
		Concept mlcConcept = Context.getConceptService().getConcept(
				RegistrationConstants.CONCEPT_NAME_MEDICO_LEGAL_CASE);

		Obs mlcObs = new Obs();
		if (!StringUtils
				.isBlank(parameters
						.get(RegistrationConstants.FORM_FIELD_PATIENT_MLC))) {
			Concept selectedMlcConcept = Context
					.getConceptService()
					.getConcept(
							parameters
									.get(RegistrationConstants.FORM_FIELD_PATIENT_MLC));
			mlcObs.setConcept(mlcConcept);
			mlcObs.setValueCoded(selectedMlcConcept);
			encounter.addObs(mlcObs);
		}/* else {
			mlcObs.setConcept(mlcConcept);
			mlcObs.setValueCoded(Context.getConceptService().getConcept(
					"NO"));
			encounter.addObs(mlcObs);
		}*/
		
		/*
		 * REFERRAL INFORMATION
		 */
		Obs referralObs = new Obs();
		Concept referralConcept = Context
				.getConceptService()
				.getConcept(
						RegistrationConstants.CONCEPT_NAME_PATIENT_REFERRED_TO_HOSPITAL);
		referralObs.setConcept(referralConcept);
		encounter.addObs(referralObs);
		if (!StringUtils.isBlank(parameters
				.get(RegistrationConstants.FORM_FIELD_PATIENT_REFERRED_FROM))) {
			referralObs.setValueCoded(Context.getConceptService().getConcept(
					"YES"));

			// referred from
			Obs referredFromObs = new Obs();
			Concept referredFromConcept = Context
					.getConceptService()
					.getConcept(
							RegistrationConstants.CONCEPT_NAME_PATIENT_REFERRED_FROM);
			referredFromObs.setConcept(referredFromConcept);
			referredFromObs
					.setValueCoded(Context
							.getConceptService()
							.getConcept(
									Integer.parseInt(parameters
											.get(RegistrationConstants.FORM_FIELD_PATIENT_REFERRED_FROM))));
			encounter.addObs(referredFromObs);

			// referred reason
			Obs referredReasonObs = new Obs();
			Concept referredReasonConcept = Context
					.getConceptService()
					.getConcept(
							RegistrationConstants.CONCEPT_NAME_REASON_FOR_REFERRAL);
			referredReasonObs.setConcept(referredReasonConcept);
			referredReasonObs
					.setValueCoded(Context
							.getConceptService()
							.getConcept(
									Integer.parseInt(parameters
											.get(RegistrationConstants.FORM_FIELD_PATIENT_REFERRED_REASON))));
			referredReasonObs.setValueText(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_REFERRED_DESCRIPTION));
			encounter.addObs(referredReasonObs);
		} else {
			referralObs.setValueCoded(Context.getConceptService().getConcept(
					"NO"));
		}
		return encounter;
	}

}
