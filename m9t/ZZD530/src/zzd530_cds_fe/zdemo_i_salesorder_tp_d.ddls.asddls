@AbapCatalog.sqlViewName: 'ZDEMO_I_SOH_V'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales order for transactional app'

@Search.searchable: true

@ObjectModel: {
    -- Annotations for transactional processing
    semanticKey: ['SalesOrder'],
    compositionRoot: true,
    transactionalProcessingEnabled: true,
    createEnabled: true,
    deleteEnabled: true,
    updateEnabled: true,
    writeActivePersistence: 'zdemo_soh',

        -- Additional annotations for draft enablement
        draftEnabled: true,
         writeDraftPersistence: 'ZDEMO_SOH_D',
    -- Additional ETag annotation (time stamp)
    entityChangeStateId: 'ChangedAt'

}



define view ZDEMO_I_SalesOrder_TP_D
  as select from zdemo_soh as SalesOrder -- the sales order table is the data source for this view
  /* Compositional associations */
  association [0..*] to ZDEMO_I_SalesOrderItem_TP_D  as _Item            on $projection.SalesOrderUUID = _Item.SalesOrderUUID
  /* Cross BO associations       */
  association [0..1] to SEPM_I_BusinessPartner       as _BusinessPartner on $projection.BusinessPartner = _BusinessPartner.BusinessPartner
  /* Associations for value help */
  association [0..1] to Sepm_I_SalesOrdOverallStatus as _OverallStatus   on $projection.OverallStatus = _OverallStatus.SalesOrderOverallStatus


{
      -- UUID-based key is required to enable draft capabilities
      @ObjectModel.readOnly: true
  key SalesOrder.salesorderuuid  as SalesOrderUUID,

      @Search.defaultSearchElement: true
      @ObjectModel.readOnly: true
      SalesOrder.salesorder      as SalesOrder,

      @ObjectModel.foreignKey.association: '_BusinessPartner'
      SalesOrder.businesspartner as BusinessPartner,

      @Semantics.systemDate.lastChangedAt: true
      SalesOrder.changedat       as ChangedAt,

      @Search.defaultSearchElement: true
      @ObjectModel.foreignKey.association: '_OverallStatus'
      SalesOrder.overallstatus   as OverallStatus,

      @Semantics.systemDateTime.createdAt: true
      SalesOrder.createdat       as CreatedAt,
      @Semantics.user.createdBy: true
      SalesOrder.createdby       as CreatedBy,
      @Semantics.user.lastChangedBy: true
      SalesOrder.changedby       as ChangedeBy,


      /* Associations */
      @ObjectModel.association.type: [#TO_COMPOSITION_CHILD]
      _Item,
      _BusinessPartner,
      _OverallStatus


}
