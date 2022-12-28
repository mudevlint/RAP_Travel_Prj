@AbapCatalog.sqlViewName: 'ZV_HC_MST2295'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Root View Master 2295'
define root view z_i_hc_master_2295 as select from zhc_master_2295 as hcmmaster {
     //HCMMaster
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
