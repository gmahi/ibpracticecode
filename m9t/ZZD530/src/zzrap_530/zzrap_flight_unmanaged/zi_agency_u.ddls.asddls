@AbapCatalog.sqlViewName: 'ZI_AGENCYU'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Agency View- CDS Data mdel'

@Search.searchable: true

define view ZI_AGENCY_U
  as select from /dmo/agency as Agency -- the agency table serves as the data source for this view

association [0..1] to I_Country as _Country on $projection.CountryCode = _Country.Country

{
      ///dmo/agency
  key Agency.agency_id     as AgencyID,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      Agency.name          as Name,
      Agency.street        as Street,
      Agency.postal_code   as PostalCode,
      Agency.city          as City,
      Agency.country_code  as CountryCode,
      Agency.phone_number  as PhoneNumber,
      Agency.email_address as EmailAddress,
      Agency.web_address   as WebAddress,
      
      //Associtians
      _Country

}
