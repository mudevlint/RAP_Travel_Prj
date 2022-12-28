@AbapCatalog.sqlViewName: 'ZV_EMPLOYEE2295'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root View Employees 2295'
define root view Z_I_EMPLOYEES_2295
  as select from ztb_employee2295 as Employees
{
  key e_number,
      e_name,
      e_department,
      status,
      job_title,
      start_date,
      end_date,
      email,
      m_number,
      m_name,
      m_department,
      crea_date_time,
      crea_uname,
      lchg_date_time,
      lchg_uname
}
