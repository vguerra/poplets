ad_library {
  Procedures to supports admin portlets.
  
  @creation-date __creation_date__
  @author __author_name__
}


Object __pkg_key___admin_portlet
__pkg_key___admin_portlet proc name {} {
  return "__pkg_key__-admin-portlet"
}

__pkg_key___admin_portlet proc pretty_name {} {
  return "__pkg__prettyName"
}

__pkg_key___admin_portlet proc package_key {} {
  return "__pkg_key__-portlet"
}

__pkg_key___admin_portlet proc link {} {
  return ""
}

__pkg_key___admin_portlet ad_proc add_self_to_page {
  {-portal_id:required}
  {-package_id:required}
} {
  Adds a xowiki admin PE to the given portal
} {
  return [portal::add_element_parameters \
              -portal_id $portal_id \
              -portlet_name [my name] \
              -key package_id \
              -value $package_id \
             ]
  ns_log notice "end of add_self_to_page"
}

__pkg_key___admin_portlet ad_proc remove_self_from_page {
  {-portal_id:required}
} {
  Removes xowiki admin PE from the given page
} {
  # This is easy since there's one and only one instace_id
  portal::remove_element \
      -portal_id $portal_id \
      -portlet_name [my name]
}

__pkg_key___admin_portlet ad_proc show {
  cf
} {
  Display the xowiki admin PE
} {
  portal::show_proc_helper \
      -package_key [my package_key] \
      -config_list $cf \
      -template_src "admin-portlet"
}

__pkg_key___admin_portlet proc install {} {
  my log "--portlet calling [self proc]"
  set name [my name]
  db_transaction {

    #
    # create the datasource
    #
    set ds_id [::xo::db::sql::portal_datasource new -name $name \
                   -css_dir "" \
                   -description "Displays the admin interface for the xowiki data portlets"]
    
    # default configuration
    
    ::xo::db::sql::portal_datasource set_def_param -datasource_id $ds_id \
        -config_required_p t -configured_p t \
        -key "shadeable_p" -value f
    
    ::xo::db::sql::portal_datasource set_def_param -datasource_id $ds_id \
        -config_required_p t -configured_p t \
        -key "shaded_p" -value f
    
    ::xo::db::sql::portal_datasource set_def_param -datasource_id $ds_id \
        -config_required_p t -configured_p t \
        -key "hideable_p" -value t
    
    ::xo::db::sql::portal_datasource set_def_param -datasource_id $ds_id \
        -config_required_p t -configured_p t \
        -key "user_editable_p" -value f
    
    ::xo::db::sql::portal_datasource set_def_param -datasource_id $ds_id \
        -config_required_p t -configured_p t \
        -key "link_hideable_p" -value t
    
    # xowiki-admin-specific procs
    
    # package_id must be configured
    ::xo::db::sql::portal_datasource set_def_param -datasource_id $ds_id \
        -config_required_p t -configured_p f \
        -key "package_id" -value ""
    
    
    #
    # service contract managemet
    #
    # create the implementation
    ::xo::db::sql::acs_sc_impl new \
        -impl_contract_name "portal_datasource" -impl_name $name \
        -impl_pretty_name "" -impl_owner_name $name
    
    # add the operations
    foreach {operation call} {
      GetMyName     	"__pkg_key___admin_portlet name"
      GetPrettyName 	"__pkg_key___admin_portlet pretty_name"
      Link          	"__pkg_key___admin_portlet link"
      AddSelfToPage 	"__pkg_key___admin_portlet add_self_to_page"
      Show          	"__pkg_key___admin_portlet show"
      Edit          	"__pkg_key___admin_portlet edit"
      RemoveSelfFromPage	"__pkg_key___admin_portlet remove_self_from_page"
    } {
      ::xo::db::sql::acs_sc_impl_alias new \
          -impl_contract_name "portal_datasource" -impl_name $name  \
          -impl_operation_name $operation -impl_alias $call \
          -impl_pl "TCL"
    }
    
    # Add the binding
    ::xo::db::sql::acs_sc_binding new \
        -contract_name "portal_datasource" -impl_name $name
  }
  my log "--portlet end of [self proc]"
}

__pkg_key___admin_portlet proc uninstall {} {
  my log "--portlet calling [self proc]"
  #
  # completely identical to "xowiki_portlet uninstall"
  #
  set name [my name]
  db_transaction {

    # 
    # get the datasource
    #
    set ds_id [db_string dbqd..get_ds_id {
      select datasource_id from portal_datasources where name = :name
    } -default "0"]
    
    if {$ds_id != 0} {
      #
      # drop the datasource
      #
      ::xo::db::sql::portal_datasource delete -datasource_id $ds_id
      #
    } else {
      ns_log notice "No datasource id found for $name"
    }

    #  drop the operations
    #
    foreach operation {
      GetMyName GetPrettyName Link AddSelfToPage 
      Show Edit RemoveSelfFromPage
    } {
      ::xo::db::sql::acs_sc_impl_alias delete \
          -impl_contract_name "portal_datasource" -impl_name $name \
          -impl_operation_name $operation
    }
    #
    #  drop the binding
    #
    ::xo::db::sql::acs_sc_binding delete \
        -contract_name "portal_datasource" -impl_name $name
    #
    #  drop the implementation
    #
    ::xo::db::sql::acs_sc_impl delete \
        -impl_contract_name "portal_datasource" -impl_name $name 
  }  
  my log "--portlet end of [self proc]"
}
  



