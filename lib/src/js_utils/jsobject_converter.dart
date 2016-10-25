part of tekartik_browser_utils_js_utils;

List<String> jsObjectKeys(JsObject jsObject) {
  if (jsObject is JsArray) {
    throw new ArgumentError('object is an array');
  }
  JsArray jsKeys = context['Object'].callMethod('keys', [jsObject]);
  List<String> keys = new List();
  for (int i = 0; i < jsKeys.length; i++) {
    keys.add(jsKeys[i]);
  }
  return keys;
}

/**
 * For JsObject of JsArray
 */
dynamic jsObjectAsCollection(JsObject jsObject, {int depth}) {
  if (jsObject is JsArray) {
    return jsArrayAsList(jsObject, depth: depth);
  }
  return jsObjectAsMap(jsObject, depth: depth);
}

List jsArrayAsList(JsArray jsArray, {int depth}) {
  if (jsArray == null) {
    return null;
  }
  _Converter context = new _Converter();
  return context.jsArrayToList(jsArray, [], depth: depth);
}

///
/// Handle element already in jsCollections
///
Map jsObjectAsMap(JsObject jsObject, {int depth}) {
  if (jsObject == null) {
    return null;
  }
  _Converter context = new _Converter();
  return context.jsObjectToMap(jsObject, {}, depth: depth);
}

class _Converter {
  Map<JsObject, dynamic> jsCollections = {};

  dynamic jsObjectToCollection(JsObject jsObject, {int depth}) {
    if (jsCollections.containsKey(jsObject)) {
      return jsCollections[jsObject];
    }
    if (jsObject is JsArray) {
      // create the list before
      return jsArrayToList(jsObject, [], depth: depth);
    } else {
      // create the map before for recursive object
      return jsObjectToMap(jsObject, {}, depth: depth);
    }
  }

  Map jsObjectToMap(JsObject jsObject, Map map, {int depth}) {
    jsCollections[jsObject] = map;
    List<String> keys = jsObjectKeys(jsObject);

    // Stop
    if (depth == 0) {
      return {".": "."};
    }

    // Handle recursive objects
    for (String key in keys) {
      var value = jsObject[key];
      if (value is JsObject) {
        // recursive
        value = jsObjectToCollection(value,
            depth: depth == null ? null : depth - 1);
      }
      map[key] = value;
    }
    return map;
  }

  List jsArrayToList(JsArray jsArray, List list, {int depth}) {
    if (depth == 0) {
      return [".."];
    }
    jsCollections[jsArray] = list;
    for (int i = 0; i < jsArray.length; i++) {
      var value = jsArray[i];
      if (value is JsObject) {
        value = jsObjectToCollection(value,
            depth: depth == null ? null : depth - 1);
      }
      list.add(value);
    }
    return list;
  }
}
