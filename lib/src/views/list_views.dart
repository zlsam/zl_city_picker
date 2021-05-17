import 'package:flutter/material.dart';
import 'package:zl_city_picker/src/models/code_model.dart';

class ListViews extends StatefulWidget {
  ListViews(this.data,
      {Key? key,
      this.onTap,
      this.selectColor,
      this.selectData = const [],
      required this.tabIndex})
      : super(key: key);

  /// datas
  final List<CodeModel> data;

  /// ontap
  final ValueChanged<CodeModel>? onTap;

  /// select color
  final Color? selectColor;

  /// select data
  final List<CodeModel>? selectData;

  /// tab index
  final int tabIndex;

  @override
  _ListViewsState createState() => _ListViewsState();
}

class _ListViewsState extends State<ListViews> {
  CodeModel? _selectData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.data.length,
        itemExtent: 40,
        padding: EdgeInsets.symmetric(vertical: 10),
        itemBuilder: (BuildContext context, int index) {
          if (widget.selectData!.length>0&&widget.selectData!.length-1 >= widget.tabIndex) {
            _selectData = widget.selectData![widget.tabIndex];
          }
          return InkWell(
            onTap: () {
              _selectData = widget.data[index];
              widget.onTap?.call(widget.data[index]);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: widget.data[index].value == _selectData?.value
                    ? [
                        _selectData != null
                            ? Icon(
                                Icons.check_rounded,
                                color: widget.selectColor,
                              )
                            : Container(),
                        _selectData != null
                            ? SizedBox(
                                width: 10,
                              )
                            : Container(),
                        Text(
                          widget.data[index].name,
                          style: TextStyle(color: widget.selectColor),
                        ),
                      ]
                    : [
                        Text(
                          widget.data[index].name,
                        )
                      ],
              ),
            ),
          );
        });
  }
}
