class DocumentUDateRequestModel {
  String? pApplicationNo;
  int? pId;
  String? pSourceDoc;
  String? pEffectiveDate;
  String? pExpiredDate;
  String? pPromiseDate;

  DocumentUDateRequestModel(
      {this.pApplicationNo,
      this.pId,
      this.pSourceDoc,
      this.pEffectiveDate,
      this.pExpiredDate,
      this.pPromiseDate});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['p_application_no'] = pApplicationNo;
    data['p_id'] = pId;
    data['p_source_doc'] = pSourceDoc;
    data['p_promise_date'] = pPromiseDate;
    data['p_effective_date'] = pEffectiveDate;
    data['p_expired_date'] = pExpiredDate;
    return data;
  }
}
