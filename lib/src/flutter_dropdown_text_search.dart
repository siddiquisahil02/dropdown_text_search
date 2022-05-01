import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DropdownTextSearch extends StatefulWidget {
  final TextEditingController? controller;
  final InputDecoration? decorator;
  final String? noItemFoundText;
  final Color? hoverColor;
  final Color? highlightColor;
  final Color? tileColor;
  final FocusScopeNode? node;
  final bool Function(String a,String b) filterFnc;
  final double overlayHeight;
  final Function(String val) onChange;
  final List<String> items;

  const DropdownTextSearch({Key? key,
    required this.onChange,
    required this.overlayHeight,
    required this.items,
    required this.filterFnc,
    this.controller,
    this.decorator,
    this.node,
    this.hoverColor,
    this.highlightColor,
    this.tileColor,
    this.noItemFoundText,
  }) : super(key: key);

  @override
  _DropdownTextSearch createState() => _DropdownTextSearch();
}

class _DropdownTextSearch extends State<DropdownTextSearch> {

  late final ScrollController scrollController;
  late List<String> sourceData;
  late final FocusNode focusNode;
  final layerLink = LayerLink();
  OverlayEntry? entry;
  int _selectedItem = 0;

  @override
  void initState() {
    scrollController = ScrollController();
    sourceData = widget.items;
    focusNode = FocusNode();
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_){});

    focusNode.addListener((){
      if(focusNode.hasFocus){
        showOverlay();
      }else{
        hideOverlay();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    focusNode.dispose();
    entry?.dispose();
    super.dispose();
  }

  void showOverlay(){
    final overlay = Overlay.of(context)!;
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    entry = OverlayEntry(
      builder: (BuildContext context)=>Positioned(
          width: size.width,
          child: CompositedTransformFollower(
              link: layerLink,
              showWhenUnlinked: false,
              offset: Offset(0,size.height+10),
              child: buildOverlay()
          )
      ),
    );

    overlay.insert(entry!);
  }

  void hideOverlay(){
    entry?.remove();
    entry = null;
  }

  Widget buildOverlay(){
    return Material(
        elevation: 10,
        child: SizedBox(
          height: widget.overlayHeight,
          child: sourceData.isNotEmpty
              ?ListView.builder(
            shrinkWrap: true,
            controller: scrollController,
            itemBuilder: (context, index){
              return ListTile(
                title: Text(sourceData[index]),
                hoverColor: widget.hoverColor??Colors.grey.shade200,
                tileColor: index==_selectedItem?(widget.highlightColor??Colors.grey.shade300):widget.tileColor,
                onTap: () {
                  if(widget.controller!=null){
                    widget.controller!.text = sourceData[index];
                  }
                  widget.onChange.call(sourceData[index]);
                  focusNode.unfocus();
                },
              );
            },
            itemCount: sourceData.length,
          )
              :Center(child: Text(widget.noItemFoundText??"No Item Found")),
        )
    );
  }

  void scrollFun(){
    double perBlockHeight = scrollController.position.maxScrollExtent / (sourceData.length - 1);
    double _position = _selectedItem * perBlockHeight;
    scrollController.jumpTo(
      _position,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: focusNode,
      onKey: (RawKeyEvent key){
        if(key.isKeyPressed(LogicalKeyboardKey.arrowDown)){
          _selectedItem = _selectedItem<sourceData.length-1?_selectedItem+1:_selectedItem;
          scrollFun();
        }else if(key.isKeyPressed(LogicalKeyboardKey.arrowUp)){
          _selectedItem = _selectedItem>0?_selectedItem-1:_selectedItem;
          scrollFun();
        }else if(key.isKeyPressed(LogicalKeyboardKey.escape)){
          if(widget.controller!=null){
            widget.controller!.clear();
          }
          focusNode.unfocus();
        }
        entry!.markNeedsBuild();
      },
      child: CompositedTransformTarget(
        link: layerLink,
        child: TextFormField(
          controller: widget.controller,
          autofocus: false,
          onFieldSubmitted: (bg){
            if(widget.controller!=null){
              widget.controller!.text = sourceData[_selectedItem];
            }
            widget.onChange.call(sourceData[_selectedItem]);
            focusNode.unfocus();
          },
          onEditingComplete: widget.node?.nextFocus,
          cursorColor: Colors.black,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.black),
          onChanged: (val){
            if(val.isNotEmpty){
              sourceData = widget.items.where((element) =>
                  widget.filterFnc.call(element,val)
              ).toList();
            }else{
              sourceData = widget.items;
            }
            _selectedItem = 0;
            setState(() {});
          },
          decoration: widget.decorator,
        ),
      ),
    );
  }
}