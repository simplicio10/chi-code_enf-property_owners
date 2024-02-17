
library(tidyverse)

# data and documentation available at https://www.ilsos.gov/data/bus_serv_home.html
# files are updated on (roughly) a daily or weekly basis
# script currently based on already downloaded files but can be updated to download new files
# the files are provided as fwfs and have a first and last row containing metadata hence the weird head(-1) thing


# import llcs ####

# llc master
llc_master <- 
  read_fwf(
    "sos_business_data/llcallmst.txt",
    col_positions = fwf_widths(c(8, 6, 2, 8, 8, 8, 1, 2, 45, 30, 9, 2, 1, 1, 1, 1, 1, 1, 1),
                               c("ll_file_nbr", "ll_purpose_code", "ll_status_code",
                                 "ll_status_date", "ll_organized_date", "ll_dissolution_date",
                                 "ll_management_type", "ll_juris_organized", "ll_records_off_street",
                                 "ll_records_off_city", "ll_records_off_zip", "ll_records_off_juris",
                                 "ll_assumed_ind", "ll_old_ind", "ll_provisions_ind",
                                 "ll_opt_ind", "ll_series_ind", "ll_uap_ind", "ll_l3c_ind")),
    locale = locale(date_format = "%Y%m%d"),
    col_types = "nnnDDDncccccnnnnccc",
    skip = 1
  ) |> 
  head(-1)
# problems are for 99999999 (or similar invalid) dates & last line

# llc names
llc_name <- 
  read_fwf(
    "sos_business_data/llcallnam.txt",
    col_positions = fwf_widths(c(8, 120),
                               c("ll_file_nbr", "ll_name")),
    col_types = "nc",
    skip = 1
  )|> 
  head(-1)
# problems are for last line


# llc agent
llc_agent <-
  read_fwf(
    "sos_business_data/llcallagt.txt",
    col_positions = fwf_widths(c(8, 1, 60, 45, 30, 9, 3, 8),
                               c("ll_file_nbr", "ll_agent_code", "ll_agent_name", 
                                 "ll_agent_street", "ll_agent_city", "ll_agent_zip",
                                 "ll_agent_country_code",  "ll_agent_change_date")),
    col_types = "nccccnnD",
    locale = locale(date_format = "%Y%m%d"),
    skip = 1
  )|> 
  head(-1)

# llc managers
llc_managers <- 
  read_fwf(
    "sos_business_data/llcallmgr.txt",
    col_positions = fwf_widths(c(8, 60, 45, 30, 2, 9, 8, 1),
                               c("ll_file_nbr", "ll_manager_name", 
                                 "ll_manager_street", "ll_manager_city", "ll_manager_juris",
                                 "ll_manager_zip", "ll_manager_file_date", "ll_manager_type_code")),
    col_types = "ncccccDn",
    locale = locale(date_format = "%Y%m%d"),
    skip = 1
  )|> 
  head(-1)
# problems are for ivnalid dates & last line

# llc assumed name
llc_assumed_name <- 
  read_fwf(
    "sos_business_data/llcallase.txt",
    col_positions = fwf_widths(c(8, 8, 8, 1, 4, 8, 1, 240, 3),
                               c("ll_file_nbr", "ll_asmd_adopt_date", "ll_asmd_can_date",
                                 "ll_asmd_can_code", "ll_asmd_renew_yr", "ll_asmd_renew_date",
                                 "ll_asmd_ind", "ll_llc_name", "ll_series_nbr")),
    col_types = "nDDnnDncn",
    locale = locale(date_format = "%Y%m%d"),
    skip = 1
  ) |> 
  head(-1)
# problems are for invalid dates & last line

# llc old name
llc_old_name <- 
  read_fwf(
    "sos_business_data/llcallold.txt",
    col_positions = fwf_widths(c(8, 8, 120, 3),
                               c("ll_file_nbr", "ll_old_date_filed", "ll_llc_name", "ll_series_nbr")),
    col_types = "nDcn",
    locale = locale(date_format = "%Y%m%d"),
    skip = 1
  )|> 
  head(-1)
# problems are for invalid dates & last line

# llc series names
llc_series_name <- 
  read_fwf(
    "sos_business_data/llcallser.txt",
    col_positions = fwf_widths(c(8, 3, 2, 8, 8, 8, 240),
                               c("ll_file_nbr", "ll_series_nbr", "ll_series_status",
                                 "ll_status_date", "ll_begin_date", "ll_disltn_date", "ll_series_name")),
    col_types = "nnnDDDc",
    locale = locale(date_format = "%Y%m%d"),
    skip = 1
  )|> 
  head(-1)
# problems are for 00000000/invalid dates & last line


# import corporations ####

# corp master
corp_master <- 
  read_fwf(
    "https://www.ilsos.gov/data/bs/cdxallmst.zip",
    col_positions = fwf_widths(c(8, 8, 8, 2, 3, 2, 1, 8, 60, 60),
                               c("corp_file_nbr", "corp_incorp_date", "corp_extend_date",
                                 "corp_state_code", "corp_intent", "corp_status",
                                 "corp_type", "corp_trans_date", "corp_pres", "corp_sec")),
    col_types = "nDDnnnnDcc",
    locale = locale(date_format = "%Y%m%d"),
    skip = 1
  )|> 
  head(-1)
# problems are for 00000000 dates & last line

# corp name
corp_name <- 
  read_fwf(
    "sos_business_data/cdxallnam.txt",
    col_positions = fwf_widths(c(8, 189),
                               c("corp_file_nbr", "corp_name")),
    col_types = "nc",
    skip = 1
  )|> 
  head(-1)
# problem is last line

# corp agent 
corp_agent <- 
  read_fwf(
    "sos_business_data/cdxallagt.txt",
    col_positions = fwf_widths(c(8, 60, 45, 30, 8, 1, 9, 3),
                               c("corp_file_nbr", "corp_agent_name", "corp_agent_street", "corp_agent_city",
                                 "corp_agent_change_date", "corp_agent_code",
                                 "corp_agent_zip", "corp_agent_country_code")),
    col_types = "ncccncnn"
  ) |> 
  head(-1)
# problems are for last line


# corp assumed old name

corp_asmd_old_name <- 
  read_fwf(
    "sos_business_data/cdxallaon.txt",
    col_positions = fwf_widths(c(8, 8, 8, 1, 8, 189),
                               c("corp_file_nbr", "corp_date_cancel", "corp_asmd_curr_date",
                                 "corp_asmd_old_ind", "corp_asmd_old_date", "corp_asmd_old_name")),
    col_types = "nccnDc",
    locale = locale(date_format = "%Y%m%d"),
    skip = 1
  )|> 
  head(-1)
# problems are for invalid dates & last line


