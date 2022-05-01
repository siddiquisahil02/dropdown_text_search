<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

# Dropdown Text Search

![](https://img.shields.io/badge/BK14-Billi-red)
![](https://img.shields.io/github/languages/top/siddiquisahil02/dropdown_text_search)
![](https://img.shields.io/github/last-commit/siddiquisahil02/dropdown_text_search)


## Features

A Dropdown List with TextField search and Keyboard support.

**Arrow_UP & Arrow_DOWN** : for travelling in the list

**Enter_KEY** : Selects the current selected item in the list

**Escape_KEY** : Closes the Dropdown overlay and reset the search TextField


<img src="https://raw.githubusercontent.com/siddiquisahil02/dropdown_text_search/main/assets/example.gif"  height = "500" >

Note : Currently, only working for String list items.

## Getting started

Add this line to your file.

```dart
import 'package:dropdown_text_search/src/flutter_dropdown_text_search.dart';
```

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder. 

```dart
SizedBox(
    width: 250,
    child: DropdownTextSearch(
        onChange: (val){
            print(val);
            _controller.text = val;
        },
        noItemFoundText: "Invalid Search",
        controller: _controller,
        overlayHeight: 300,
        items: citiesData,
        filterFnc: (String a,String b){
          return a.toLowerCase().startsWith(b.toLowerCase());
        },
        decorator: UIComponents.inputDecoration(
            context: context,
            hint: "All"
        ),
    )
)
```

## Additional information

Repo: [dropdown_text_search](https://github.com/siddiquisahil02/dropdown_text_search)

Found any issues, report [here](https://github.com/siddiquisahil02/dropdown_text_search/issues)


