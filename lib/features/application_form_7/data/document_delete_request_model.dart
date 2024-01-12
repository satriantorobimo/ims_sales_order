class DocumentDeleteRequestModel {
  String? pHeader;
  int? pId;
  String? pFileName;
  String? pFilePaths;

  DocumentDeleteRequestModel(
      {this.pHeader, this.pFileName, this.pFilePaths, this.pId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['p_header'] = pHeader;
    data['p_file_name'] = pFileName;
    data['p_file_paths'] = pFilePaths;
    data['p_id'] = pId;
    return data;
  }
}
