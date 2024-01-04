class DocumentUploadRequestModel {
  String? pModule;
  String? pHeader;
  String? pChild;
  int? pId;
  int? pFilePaths;
  String? pFileName;
  String? pBase64;

  DocumentUploadRequestModel(
      {this.pModule,
      this.pHeader,
      this.pChild,
      this.pId,
      this.pFilePaths,
      this.pFileName,
      this.pBase64});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['p_module'] = pModule;
    data['p_header'] = pHeader;
    data['p_child'] = pChild;
    data['p_id'] = pId;
    data['p_file_paths'] = pFilePaths;
    data['p_file_name'] = pFileName;
    data['p_base64'] = pBase64;
    return data;
  }
}
