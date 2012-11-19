ad_library {
  Procedures to supports portlets.
  
  @creation-date __creation_date__
  @author __author_name__
}

# This has been generated with a portlet 
# applet template based on the xowiki portlet code.

::xotcl::Object create __pkg_key___portlet
__pkg_key___portlet proc name {} {
  return "__pkg_key___portlet"
}

__pkg_key___portlet proc pretty_name {} {
  return "__pkg_prettyName__"
}

__pkg_key___portlet proc package_key {} {
  return "__pkg_key__-portlet"
}

__pkg_key___portlet proc link {} {
  return ""
}

__pkg_key___portlet ad_proc add_self_to_page {
  {-portal_id:required}
  {-package_id:required}
} {
  Adds a PE to the given page
} {
  return [portal::add_element_parameters \
            -portal_id $portal_id \
            -portlet_name [my name] \
            -key package_id \
            -value $package_id \
         ]
  ns_log notice "end of add_self_to_page"
}

__pkg_key___portlet ad_proc remove_self_from_page {
  portal_id
  element_id
} {
  Removes PE from the given page
} {
  portal::remove_element \
      -portal_id $portal_id \
      -portlet_name [my name]
}

__pkg_key___portlet ad_proc show {cf} {
} {
  portal::show_proc_helper \
      -package_key [my package_key] \
      -config_list $cf \
      -template_src "portlet"
}

#
# install
#
__pkg_key___portlet proc install {} {
  my log "--portlet calling [self proc]"
  set name [my name]
  #
  # create the datasource
  #
  db_transaction {
    set css_dir ""
    set description "Displays a __pkg_key__ portlet"

    set ds_id [db_exec_plsql create_datasource {
      select portal_datasource__new(
        :name,
        :description,
        :css_dir
        )
      }]
    
    # default configuration
    ::xo::db::sql::portal_datasource set_def_param -datasource_id $ds_id \
        -config_required_p t -configured_p t \
        -key "shadeable_p" -value t
    
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
    
    # xowiki-specific configuration
    
    ::xo::db::sql::portal_datasource set_def_param -datasource_id $ds_id \
        -config_required_p t -configured_p f \
        -key "package_id" -value ""
    
    #    ::xo::db::sql::portal_datasource set_def_param -datasource_id $ds_id \
    #      -config_required_p t -configured_p f \
	  # -key "page_name" -value ""
    
    #
    # service contract managemet
    #
    # create the implementation
    ::xo::db::sql::acs_sc_impl new \
        -impl_contract_name "portal_datasource" -impl_name $name \
        -impl_pretty_name "" -impl_owner_name $name
    
    # add the operations
    foreach {operation call} {
      GetMyName     	"__pkg_key___portlet name"
      GetPrettyName 	"__pkg_key___portlet pretty_name"
      Link          	"__pkg_key___portlet link"
      AddSelfToPage 	"__pkg_key___portlet add_self_to_page"
      Show          	"__pkg_key___portlet show"
      Edit          	"__pkg_key___portlet edit"
      RemoveSelfFromPage	"__pkg_key___portlet remove_self_from_page"
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

#
# uninstall
#

__pkg_key___portlet proc uninstall {} {
  my log "--portlet calling [self proc]"
  #
  # completely identical to "xowiki_admin_portlet uninstall"
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

    #
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

::__pkg_key___portlet proc after-install {} {
  ::__pkg_key___portlet install
  ::__pkg_key___admin_portlet install
}

::__pkg_key___portlet proc before-uninstall {} {
  ::__pkg_key___portlet uninstall
  ::__pkg_key____admin_portlet uninstall
}