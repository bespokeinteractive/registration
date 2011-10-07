/**
 *  Copyright 2011 Health Information Systems Project of India
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

package org.openmrs.module.registration.db.hibernate;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Criteria;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Expression;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.openmrs.Patient;
import org.openmrs.PersonAttribute;
import org.openmrs.PersonAttributeType;
import org.openmrs.module.registration.db.RegistrationDAO;
import org.openmrs.module.registration.model.RegistrationFee;

public class HibernateRegistrationDAO implements RegistrationDAO {

	private SessionFactory sessionFactory;
	private static SimpleDateFormat mysqlDateTimeFormatter = new SimpleDateFormat(
			"yyyy-MM-dd hh:mm:ss");
	private static SimpleDateFormat mysqlDateFormatter = new SimpleDateFormat(
			"yyyy-MM-dd");
	private static Log logger = LogFactory
			.getLog(HibernateRegistrationDAO.class);

	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sessionFactory = sessionFactory;
	}

	/*
	 * REGISTRATION FEE
	 */
	public RegistrationFee saveRegistrationFee(RegistrationFee fee) {
		return (RegistrationFee) sessionFactory.getCurrentSession().merge(fee);
	}

	public RegistrationFee getRegistrationFee(Integer id) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(
				RegistrationFee.class);
		criteria.add(Restrictions.eq("id", id));
		return (RegistrationFee) criteria.uniqueResult();
	}

	@SuppressWarnings("unchecked")
	public List<RegistrationFee> getRegistrationFees(Patient patient,
			Integer numberOfLastDate) throws ParseException {

		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(
				RegistrationFee.class);
		criteria.add(Restrictions.eq("patient", patient));
		Calendar afterDate = Calendar.getInstance();
		afterDate.add(Calendar.DATE, -numberOfLastDate);
		String afterDateFormat = mysqlDateFormatter.format(afterDate.getTime())
				+ " 00:00:00";
		logger.info(String.format(
				"getRegistrationFees(patientId=%s, afterDate=%s)",
				patient.getId(), afterDateFormat));
		criteria.add(Expression.ge("createdOn",
				mysqlDateTimeFormatter.parse(afterDateFormat)));
		criteria.addOrder(Order.desc("createdOn"));

		return criteria.list();
	}

	public void deleteRegistrationFee(RegistrationFee fee) {
		sessionFactory.getCurrentSession().delete(fee);
	}

	/*
	 * PERSON ATTRIBUTE
	 */

	@SuppressWarnings("unchecked")
	public List<PersonAttribute> getPersonAttribute(PersonAttributeType type,
			String value) {
		Criteria criteria = sessionFactory.getCurrentSession().createCriteria(
				PersonAttribute.class);
		criteria.add(Restrictions.eq("attributeType", type));
		criteria.add(Restrictions.eq("value", value));
		criteria.add(Restrictions.eq("voided", false));
		Criteria personCriteria = criteria.createCriteria("person");
		personCriteria.setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);

		return criteria.list();
	}
}
