import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/models/file_content_model.dart';
import '../../core/models/ws_message_model.dart';
import '../../core/services/view_photo_service.dart';
import '../../shared/image/image_widget.dart';

class FileContentWidget extends StatefulWidget {
  final WsMessage message;

  const FileContentWidget({Key key, @required this.message}) : super(key: key);

  @override
  _FileContentWidgetState createState() => _FileContentWidgetState();
}

class _FileContentWidgetState extends State<FileContentWidget> {
  @override
  Widget build(BuildContext context) {
    final FileContent _message = widget.message.fileContent;
    final String _mimeType = lookupMimeType(_message.value);

    if (lookupMimeType(_message.value).contains("image")) {
      return _imageContent(_message.value, _message.name, _message.comment);
    } else if (_mimeType == "application/pdf") {
        return _anyContent(_message.value, _message.name, _message.comment);
    }
    return _anyContent(_message.value, _message.name, _message.comment);
  }

  Widget _imageContent(String url, String filename, String comment) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300.0, maxHeight: 200.0),
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                final ViewPhotoService _viewPhotoService = ViewPhotoService();
                _viewPhotoService.onViewSinglePhoto(context, url);
                _viewPhotoService.dispose();
              },
              child: ImageWidget(
                url: url,
                fit: BoxFit.cover,
                radius: 20.0,
              ),
            ),
          ),
          _commentContent(comment),
        ],
      ),
    );
  }

  Widget _anyContent(String url, String filename, String comment) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300.0, maxHeight: 200.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () async {
              await launch(url, forceWebView: true, enableJavaScript: true);
            },
            child: Container(
              padding: EdgeInsets.all(10.0),
              color: Theme.of(context).cardColor,
              child: Row(
                children: [
                  Icon(Icons.insert_drive_file_rounded),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: Text(
                      "$filename",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Icon(Icons.download_rounded),
                ],
              ),
            ),
          ),
          _commentContent(comment),
        ],
      ),
    );
  }

  Widget _commentContent(String comment) {
    if (comment == null)
      return Container();
    else if (comment.trim().isEmpty) return Container();
    return SelectableText(comment);
  }
}
