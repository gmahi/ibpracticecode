*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

 TYPES:BEGIN OF ty_customer,
            kunnr TYPE kunnr,
            name1 TYPE name1_gp,
          END OF ty_customer,
          BEGIN OF ty_customer_sales,
            kunnr TYPE kunnr,
            month TYPE i,
            sales TYPE  i,
          END OF ty_customer_sales,
          BEGIN OF ty_customer_total_sales,
            kunnr       TYPE kunnr,
            name1       TYPE name1_gp,
            total_sales TYPE i,
          END OF ty_customer_total_sales,
          tt_customer             TYPE SORTED TABLE OF  ty_customer WITH UNIQUE KEY kunnr,
          tt_customer_sales       TYPE SORTED TABLE OF ty_customer_sales WITH NON-UNIQUE KEY kunnr,
          tt_customer_total_sales TYPE STANDARD TABLE OF ty_customer_total_sales,
          tt_customer_std         TYPE STANDARD TABLE OF ty_customer,
          tt_customer_sales_std   TYPE STANDARD TABLE OF ty_customer_sales.
