/**
 *  Copyright 2008 Society for Health Information Systems Programmes, India (HISP India)
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
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.Concept;
import org.openmrs.Encounter;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.PersonAttribute;
import org.openmrs.PersonAttributeType;
import org.openmrs.User;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.util.GlobalPropertyUtil;
import org.openmrs.module.hospitalcore.util.HospitalCoreUtils;
import org.openmrs.module.hospitalcore.util.ObsUtils;
import org.openmrs.module.registration.RegistrationService;
import org.openmrs.module.registration.includable.validator.attribute.PatientAttributeValidatorService;
import org.openmrs.module.registration.model.RegistrationFee;
import org.openmrs.module.registration.util.RegistrationConstants;
import org.openmrs.module.registration.util.RegistrationUtils;
import org.openmrs.module.registration.web.controller.util.PatientModel;
import org.openmrs.module.registration.web.controller.util.RegistrationWebUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller("RegistrationShowPatientInfoController")
@RequestMapping("/module/registration/showPatientInfo.form")
public class ShowPatientInfoController {
	
	private static Log logger = LogFactory.getLog(ShowPatientInfoController.class);
	
	@RequestMapping(method = RequestMethod.GET)
	public String showPatientInfo(@RequestParam("patientId") Integer patientId,
	                              @RequestParam(value = "encounterId", required = false) Integer encounterId,
	                              @RequestParam(value = "revisit", required = false) Boolean revisit,
	                              @RequestParam(value = "reprint", required = false) Boolean reprint, Model model)
	                                                                                                              throws IOException,
	                                                                                                              ParseException {
		Patient patient = Context.getPatientService().getPatient(patientId);
		HospitalCoreService hcs = Context.getService(HospitalCoreService.class);
		PatientModel patientModel = new PatientModel(patient);
		model.addAttribute("patient", patientModel);
		model.addAttribute("MEDICOLEGALCASE", RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_MEDICO_LEGAL_CASE));
		// Get current date
		SimpleDateFormat sdf = new SimpleDateFormat("EEE dd/MM/yyyy kk:mm");
		model.addAttribute("currentDateTime", sdf.format(new Date()));
		
		// Get patient registration fee
		if (GlobalPropertyUtil.getInteger(RegistrationConstants.PROPERTY_NUMBER_OF_DATE_VALIDATION, 0) > 0) {
			List<RegistrationFee> fees = Context.getService(RegistrationService.class).getRegistrationFees(patient,
			    GlobalPropertyUtil.getInteger(RegistrationConstants.PROPERTY_NUMBER_OF_DATE_VALIDATION, 0));
			if (!CollectionUtils.isEmpty(fees)) {
				RegistrationFee fee = fees.get(0);
				Calendar dueDate = Calendar.getInstance();
				dueDate.setTime(fee.getCreatedOn());
				dueDate.add(Calendar.DATE, 30);
				model.addAttribute("dueDate", RegistrationUtils.formatDate(dueDate.getTime()));
				model.addAttribute("daysLeft", dateDiff(dueDate.getTime(), new Date()));
			}
		}
		
		// Get selected OPD room if this is the first time of visit
		if (encounterId != null) {
			List<PersonAttribute> pas = hcs.getPersonAttributes(patientId);
			 for (PersonAttribute pa : pas) {
				 PersonAttributeType attributeType = pa.getAttributeType(); 
				 PersonAttributeType personAttributePaymentCategory=hcs.getPersonAttributeTypeByName("Payment Category");
				 if(attributeType.getPersonAttributeTypeId()==personAttributePaymentCategory.getPersonAttributeTypeId()){
					 model.addAttribute("selectedPaymentCategory",pa.getValue()); 
				 }
			 }
			 
			Encounter encounter = Context.getEncounterService().getEncounter(encounterId);
			for (Obs obs : encounter.getObs()) {
				if (obs.getConcept().getName().getName().equalsIgnoreCase(RegistrationConstants.CONCEPT_NAME_TRIAGE)) {
					model.addAttribute("selectedTRIAGE", obs.getValueCoded().getConceptId());
				}
				if (obs.getConcept().getName().getName().equalsIgnoreCase(RegistrationConstants.CONCEPT_NAME_OPD_WARD)) {
					model.addAttribute("selectedOPD", obs.getValueCoded().getConceptId());
				}
				if (obs.getConcept().getName().getName().equalsIgnoreCase(RegistrationConstants.CONCEPT_NAME_SPECIAL_CLINIC)) {
					model.addAttribute("selectedSPECIALCLINIC", obs.getValueCoded().getConceptId());
				}

				if (obs.getConcept().getName().getName().equalsIgnoreCase(RegistrationConstants.CONCEPT_NAME_MEDICO_LEGAL_CASE)) {
					model.addAttribute("selectedMLC", obs.getValueCoded().getConceptId());
				}
				
				if (obs.getConcept().getDisplayString().equalsIgnoreCase(RegistrationConstants.CONCEPT_NAME_REGISTRATION_FEE)) {
					double regFee=obs.getValueNumeric();
					int regFeeToInt = (int)regFee;
					model.addAttribute("registrationFee", regFeeToInt);
				}

			}
			Boolean firstTimeVisit=true;
			model.addAttribute("firstTimeVisit",firstTimeVisit);
			model.addAttribute("typeOfSlip","Registration Receipt");
		}
		
		if ((revisit != null) && revisit) {
			model.addAttribute("typeOfSlip","Registration Receipt");
			
			SimpleDateFormat spf = new SimpleDateFormat("dd/MM/yyyy");
			String  sef=spf.format(hcs.getLastVisitTime(patient));
			System.out.println("patient created day visit"+hcs.getLastVisitTime(patient));
			System.out.println("patient created day "+sef);
			String stf=spf.format(new Date());
			System.out.println("patient prevuois day visit"+spf.format(new Date()));
			System.out.println("prevuois day visit"+stf);
			//model.addAttribute("currentDateTime",stf );
			int value=stf.compareTo(sef);
			System.out.println("****"+value);
			model.addAttribute("create", value);
		}
		
		// If reprint, get the latest registration encounter
		if ((reprint != null) && reprint) {
			
			model.addAttribute("typeOfSlip","Duplicate Slip");
			SimpleDateFormat spf = new SimpleDateFormat("dd/MM/yyyy");
			String  sef=spf.format(hcs.getLastVisitTime(patient));
			String  srf=spf.format(patient.getDateCreated());
			System.out.println("patient created day visit"+hcs.getLastVisitTime(patient));
			System.out.println("patient created day "+patient.getDateCreated());
			System.out.println("patient created day "+sef);
			String stf=spf.format(new Date());
			System.out.println("patient prevuois day visit"+spf.format(new Date()));
			System.out.println("prevuois day visit"+stf);
			//model.addAttribute("currentDateTime",stf );
			int value=stf.compareTo(sef);
			int values=stf.compareTo(srf);
			System.out.println("****"+value);
			System.out.println("****"+values);
			model.addAttribute("create", value);
			model.addAttribute("creates", values);
			model.addAttribute("currentDateTime", sdf.format(hcs.getLastVisitTime(patient)));
			
			Encounter encounter = Context.getService(RegistrationService.class).getLastEncounter(patient);
			if (encounter != null) {
				Map<Integer, String> observations = new HashMap<Integer, String>();
				
				for (Obs obs : encounter.getAllObs()) {
					if (obs.getConcept().getName().getName().equalsIgnoreCase(RegistrationConstants.CONCEPT_NAME_TRIAGE)) {
						model.addAttribute("selectedTRIAGE", obs.getValueCoded().getConceptId());
					}
					if (obs.getConcept().getName().getName().equalsIgnoreCase(RegistrationConstants.CONCEPT_NAME_OPD_WARD)) {
						model.addAttribute("selectedOPD", obs.getValueCoded().getConceptId());
					}
					if (obs.getConcept().getName().getName().equalsIgnoreCase(RegistrationConstants.CONCEPT_NAME_SPECIAL_CLINIC)) {
						model.addAttribute("selectedSPECIALCLINIC", obs.getValueCoded().getConceptId());
					}

					if (obs.getConcept().getName().getName().equalsIgnoreCase(RegistrationConstants.CONCEPT_NAME_MEDICO_LEGAL_CASE)) {
						model.addAttribute("selectedMLC", obs.getValueCoded().getConceptId());
					}
					if (obs.getConcept().getDisplayString()
					        .equalsIgnoreCase(RegistrationConstants.CONCEPT_NAME_REGISTRATION_FEE)) {
						double regFee=obs.getValueNumeric();
						int regFeeToInt = (int)regFee;

						model.addAttribute("registrationFee", regFeeToInt);
					}
					observations.put(obs.getConcept().getConceptId(), ObsUtils.getValueAsString(obs));
				}
				model.addAttribute("observations", observations);
				List<PersonAttribute> pas = hcs.getPersonAttributes(patientId);
				 for (PersonAttribute pa : pas) {
					 PersonAttributeType attributeType = pa.getAttributeType(); 
					 PersonAttributeType personAttributePaymentCategory=hcs.getPersonAttributeTypeByName("Payment Category");
					 if(attributeType.getPersonAttributeTypeId()==personAttributePaymentCategory.getPersonAttributeTypeId()){
						 model.addAttribute("selectedPaymentCategory",pa.getValue()); 
					 }
				 }
			}
		}
		
		User user = Context.getAuthenticatedUser();
		model.addAttribute("reVisitFee", GlobalPropertyUtil.getString(RegistrationConstants.PROPERTY_REVISIT_REGISTRATION_FEE, ""));
		model.addAttribute("childLessThanFiveYearRegistrationFee", GlobalPropertyUtil.getString(RegistrationConstants.PROPERTY_CHILDLESSTHANFIVEYEAR_REGISTRATION_FEE, ""));
		model.addAttribute("specialClinicRegFee", GlobalPropertyUtil.getString(RegistrationConstants.PROPERTY_SPECIALCLINIC_REGISTRATION_FEE, ""));
		model.addAttribute("TRIAGE", RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_TRIAGE));
		model.addAttribute("OPDs", RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_OPD_WARD));
		model.addAttribute("SPECIALCLINIC", RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_SPECIAL_CLINIC));
		model.addAttribute("user",user);
			return "/module/registration/patient/showPatientInfo";
	}
	
	/**
	 * Get date diff betwwen 2 dates
	 * 
	 * @param d1
	 * @param d2
	 * @return
	 */
	private long dateDiff(Date d1, Date d2) {
		long diff = Math.abs(d1.getTime() - d2.getTime());
		return (diff / (1000 * 60 * 60 * 24));
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public void savePatientInfo(@RequestParam("patientId") Integer patientId,
	                            @RequestParam(value = "encounterId", required = false) Integer encounterId,
	                           // @RequestParam(value = "regFeeValue", required = false) Double selectedRegFeeValue,
	                            HttpServletRequest request, HttpServletResponse response) throws ParseException, IOException {
		
		Map<String, String> parameters = RegistrationWebUtils.optimizeParameters(request);
		
		// get patient
		Patient patient = Context.getPatientService().getPatient(patientId);
		
		/*
		 * SAVE ENCOUNTER
		 */
		Encounter encounter = null;
		if (encounterId != null) {
			encounter = Context.getEncounterService().getEncounter(encounterId);
			/*
				Concept cnrf = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_REGISTRATION_FEE);
				Concept cnp = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NEW_PATIENT);
				Obs obsn = new Obs();
				obsn.setConcept(cnrf);
				obsn.setValueCoded(cnp);
				obsn.setValueNumeric(selectedRegFeeValue);
				obsn.setValueText(selectedPaymentCategory);
				encounter.addObs(obsn);	
				*/
			HospitalCoreService hcs = Context.getService(HospitalCoreService.class);
			Obs obs=hcs.getObs(Context.getPersonService().getPerson(patient), encounter);
			//obs.setValueNumeric(selectedRegFeeValue);
		} else {
			encounter = RegistrationWebUtils.createEncounter(patient, true);
		
			if (!StringUtils.isBlank(parameters
					.get(RegistrationConstants.FORM_FIELD_PATIENT_TRIAGE))) {
				Concept triageConcept = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_TRIAGE);
				Concept selectedTRIAGEConcept = Context.getConceptService().getConcept(
				    Integer.parseInt(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_TRIAGE)));
				String selectedCategory=parameters.get(RegistrationConstants.FORM_FIELD_PAYMENT_CATEGORY);
				Obs triage = new Obs();
				triage.setConcept(triageConcept);
				triage.setValueCoded(selectedTRIAGEConcept);
				encounter.addObs(triage);
				
				// send patient to triage room
				RegistrationWebUtils.sendPatientToTriageQueue(patient, selectedTRIAGEConcept, true ,selectedCategory);
			}
			else if (!StringUtils.isBlank(parameters
					.get(RegistrationConstants.FORM_FIELD_PATIENT_OPD_WARD))) {
				Concept opdConcept = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_OPD_WARD);
				Concept selectedOPDConcept = Context.getConceptService().getConcept(
				    Integer.parseInt(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_OPD_WARD)));
				String selectedCategory=parameters.get(RegistrationConstants.FORM_FIELD_PAYMENT_CATEGORY);
				Obs opd = new Obs();
				opd.setConcept(opdConcept);
				opd.setValueCoded(selectedOPDConcept);
				encounter.addObs(opd);
				
				// send patient to opd room
				RegistrationWebUtils.sendPatientToOPDQueue(patient, selectedOPDConcept, true ,selectedCategory);
			}
			else{
				Concept specialClinicConcept = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_SPECIAL_CLINIC);
				Concept selectedSpecialClinicConcept = Context.getConceptService().getConcept(
				    Integer.parseInt(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_SPECIAL_CLINIC)));
				String selectedCategory=parameters.get(RegistrationConstants.FORM_FIELD_PAYMENT_CATEGORY);
				Obs opd = new Obs();
				opd.setConcept(specialClinicConcept);
				opd.setValueCoded(selectedSpecialClinicConcept);
				encounter.addObs(opd);
				
				// send patient to special clinic
				RegistrationWebUtils.sendPatientToOPDQueue(patient, selectedSpecialClinicConcept, true ,selectedCategory);
			}
			
			Concept mlcConcept = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_MEDICO_LEGAL_CASE);
			
			Obs mlc = new Obs();
			if (!StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_MLC))){
			Concept selectedMlcConcept = Context.getConceptService().getConcept(
			    Integer.parseInt(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_MLC)));
			
			mlc.setConcept(mlcConcept);
			mlc.setValueCoded(selectedMlcConcept);
			encounter.addObs(mlc);
			}
			/*else {
				mlc.setConcept(mlcConcept);
				mlc.setValueCoded(Context.getConceptService().getConcept("NO"));
				encounter.addObs(mlc);
			}*/
			Concept cnrffr = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_REGISTRATION_FEE);
			Concept cr = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_REVISIT);
			Double doubleVal = Double.parseDouble(parameters.get(RegistrationConstants.FORM_FIELD_REGISTRATION_FEE));
			Obs obsr = new Obs();
			obsr.setConcept(cnrffr);
			obsr.setValueCoded(cr);
			obsr.setValueNumeric(doubleVal);
			obsr.setValueText(parameters.get(RegistrationConstants.FORM_FIELD_SELECTED_PAYMENT_CATEGORY));
			obsr.setComment(parameters.get(RegistrationConstants.FORM_FIELD_SELECTED_PAYMENT_SUBCATEGORY));
			HospitalCoreService hcs = Context.getService(HospitalCoreService.class);
			List<PersonAttribute> pas = hcs.getPersonAttributes(patientId);
			 for (PersonAttribute pa : pas) {
				 PersonAttributeType attributeType = pa.getAttributeType(); 
				 PersonAttributeType personAttributePaymentCategory=hcs.getPersonAttributeTypeByName("Paying Category Type");
				 if(attributeType.getPersonAttributeTypeId()==personAttributePaymentCategory.getPersonAttributeTypeId()){
						obsr.setComment(pa.getValue());
				 }
			 }
			encounter.addObs(obsr);	
						
		}
		
		try {
			// update patient
			Patient updatedPatient = generatePatient(patient, parameters);
			patient = Context.getPatientService().savePatient(updatedPatient);
			
			// update patient attribute
			updatedPatient = setAttributes(patient, parameters);
			patient = Context.getPatientService().savePatient(updatedPatient);
			RegistrationUtils.savePatientSearch(patient);
		}
		catch (Exception e) {
		}
		
		// create temporary attributes
		/*
		for (String name : parameters.keySet()) {
			if ((name.contains(".attribute.")) && (!StringUtils.isBlank(parameters.get(name)))) {
				String[] parts = name.split("\\.");
				String idText = parts[parts.length - 1];
				Integer id = Integer.parseInt(idText);
			
				//ghanshyam  20-may-2013 #1648 capture Health ID and Registration Fee Type
				Concept concept = Context.getConceptService().getConcept(id);
				String conname=concept.getName().toString();
				
				if(conname.equals("REGISTRATION FEE")){
					Obs registrationFeeAttribute = new Obs();
					registrationFeeAttribute.setConcept(concept);
					registrationFeeAttribute .setValueAsString(parameters.get(name));
					encounter.addObs(registrationFeeAttribute);
				}
				
				if(conname.equals("REGISTRATION FEE FREE REASON")){
					Obs registrationFeeFreeReasonAttribute = new Obs();
					registrationFeeFreeReasonAttribute.setConcept(concept);
					registrationFeeFreeReasonAttribute.setValueAsString(parameters.get(name));
					encounter.addObs(registrationFeeFreeReasonAttribute);
				}
				
				if(conname.equals("MEDICO LEGAL CASE")){
					Obs temporaryAttribute = new Obs();
					temporaryAttribute.setConcept(concept);
					temporaryAttribute.setValueAsString(parameters.get(name));
					encounter.addObs(temporaryAttribute);
				}
				
				
			}
			
		}
		*/
		
		// save encounter
		Context.getEncounterService().saveEncounter(encounter);
		//logger.info(String.format("Save encounter for the visit of patient [encounterId=%s, patientId=%s]",encounter.getId(), patient.getId()));
		
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter out = response.getWriter();
		out.print("success");
	}
	
private Patient generatePatient(Patient patient, Map<String, String> parameters) throws ParseException {	
		return patient;
	}
	
	private Patient setAttributes(Patient patient, Map<String, String> attributes) throws Exception {
		PatientAttributeValidatorService validator = new PatientAttributeValidatorService();
		Map<String, Object> parameters = HospitalCoreUtils.buildParameters("patient", patient, "attributes", attributes);
		String validateResult = validator.validate(parameters);
		logger.info("Attirubte validation: " + validateResult);
		if (StringUtils.isBlank(validateResult)) {
			for (String name : attributes.keySet()) {
				if ((name.contains(".attribute.")) && (!StringUtils.isBlank(attributes.get(name)))) {
					String[] parts = name.split("\\.");
					String idText = parts[parts.length - 1];
					Integer id = Integer.parseInt(idText);
					PersonAttribute attribute = RegistrationUtils.getPersonAttribute(id, attributes.get(name));
					patient.addAttribute(attribute);
				}
			}
		} else {
			throw new Exception(validateResult);
		}
		
		return patient;
	}
	
}
