# Example D - Temporary Presistent desktop pool & edge cases

This example environment demonstrates the creation of one persistent personal ("General") pool. The sessoinhost module is looped with the count arguement. Each machine here is "personal", but temporary in lifecycle. This exists to provide workarounds for multisession application incompatibility. 

In this scenario, you would only ever provide access to basic "secure" applications on a managed image without local admin rights. 

This example also demostrates that the exclusion of workspace_id and domain will skip the creation of the domain join extension (azurerm_virtual_machine_extension.domain_join_ext) and the log analytics extension (azurerm_virtual_machine_extension.mmaagent_ext). 