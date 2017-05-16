create_project project_1 . -part xc7z020clg484-1

ipx::edit_ip_in_project -name edit ./component.xml

#set magic settings                                                                                                          
#### this one is to enable the fifo_generator instantiation                                                                  
set_property XPM_LIBRARIES {XPM_FIFO} [current_project]
