FUNCTION zget_prod_description.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_PROD_ID) TYPE  COMM_PRODUCT-PRODUCT_ID
*"  EXPORTING
*"     VALUE(RV_TEXT) TYPE  STRING
*"----------------------------------------------------------------------

  SELECT SINGLE a~short_text INTO rv_text FROM comm_prshtext  AS a
    INNER JOIN comm_product AS b ON b~product_id = iv_prod_id AND b~product_guid = a~product_guid.



ENDFUNCTION.
