/// Created by @RealCradle on 2021/6/4
///

enum BatchMethod { insert, update, delete, select, clear, remove, replace, error }
enum BatchState { ignore, success, error }

const ALL_METHODS = [
  BatchMethod.insert,
  BatchMethod.update,
  BatchMethod.delete,
  BatchMethod.select,
  BatchMethod.clear,
  BatchMethod.remove,
  BatchMethod.replace,
  BatchMethod.error
];

class BatchResult {
  final BatchState state;
  final dynamic cause;

  const BatchResult.success()
      : this.state = BatchState.success,
        this.cause = null;

  const BatchResult.error({this.cause}) : this.state = BatchState.error;

  const BatchResult.ignore({this.cause}) : this.state = BatchState.ignore;
}

const BatchResultSuccess = const BatchResult.success();

class BatchAction<T> {
  final BatchMethod method;
  final List<T> collection = <T>[];
  final BatchResult result;
  final bool Function(T)? where;
  final T Function(T)? updater;

  get length => collection.length;

  BatchAction(this.method,
      {List<T>? data, this.result = BatchResultSuccess, this.where, this.updater}) {
    if (data?.isNotEmpty == true) {
      collection.addAll(data!);
    }
  }

  void append(T? data) {
    if (data != null) {
      collection.add(data);
    }
  }

  void appendAll(List<T> data) {
    collection.addAll(data);
  }
}

class BatchData<T> {
  final List<BatchAction<T>> actions = [];

  BatchData.error(dynamic cause) {
    _append(BatchMethod.error, null, result: BatchResult.error(cause: cause));
  }

  BatchData.singleSuccess(BatchMethod method, T data) {
    _append(method, data);
  }

  BatchData.singleError(BatchMethod method, T data, BatchResult result) {
    _append(method, data, result: result);
  }

  BatchData(BatchMethod method, List<T> data, {BatchResult result = BatchResultSuccess}) {
    _appendAll(method, data, result: result);
  }

  BatchData.empty();

  void _append(BatchMethod method, T? data, {BatchResult result = BatchResultSuccess}) {
    final batchAction = actions.isNotEmpty ? actions.last : null;
    if (batchAction != null &&
        batchAction.method == method &&
        batchAction.result.state == result.state) {
      batchAction.append(data);
    } else {
      actions.add(BatchAction(method, data: (data != null) ? [data] : null, result: result));
    }
  }

  void _appendAll(BatchMethod method, List<T> data, {BatchResult result = BatchResultSuccess}) {
    if (data.isNotEmpty) {
      final batchAction = actions.isNotEmpty ? actions.last : null;
      if (batchAction != null &&
          batchAction.method == method &&
          batchAction.result.state == result.state) {
        batchAction.appendAll(data);
      } else {
        actions.add(BatchAction<T>(method, data: data, result: result));
      }
    }
  }

  void insert(T data, {BatchResult result = BatchResultSuccess}) {
    _append(BatchMethod.insert, data, result: result);
  }

  void insertAll(List<T> data, {BatchResult result = BatchResultSuccess}) {
    _appendAll(BatchMethod.insert, data, result: result);
  }

  void update(T data, {BatchResult result = BatchResultSuccess}) {
    _append(BatchMethod.update, data, result: result);
  }

  void updateAll(List<T> data, {BatchResult result = BatchResultSuccess}) {
    _appendAll(BatchMethod.update, data, result: result);
  }

  void replace({bool Function(T)? where, T Function(T)? updater, BatchResult result = BatchResultSuccess}) {
    actions.add(BatchAction(BatchMethod.replace,
        data: [],
        result: BatchResultSuccess,
        where: where ?? (_) => true,
        updater: updater ?? (r) => r));
  }

  void delete(T data, {BatchResult result = BatchResultSuccess}) {
    _append(BatchMethod.delete, data, result: result);
  }

  void deleteAll(List<T> data, {BatchResult result = BatchResultSuccess}) {
    _appendAll(BatchMethod.delete, data, result: result);
  }

  void query(T data, {BatchResult result = BatchResultSuccess}) {
    _append(BatchMethod.select, data, result: result);
  }

  void queryAll(List<T> data, {BatchResult result = BatchResultSuccess}) {
    _appendAll(BatchMethod.select, data, result: result);
  }

  void clear() {
    _append(BatchMethod.clear, null, result: BatchResultSuccess);
  }

  void removeWhere({bool Function(T)? where}) {
    actions.add(BatchAction(BatchMethod.remove,
        data: [], result: BatchResultSuccess, where: where ?? (_) => true));
  }

  bool containsMethodResult(BatchMethod method, List<BatchState> state) {
    if (isNotEmpty) {
      for (var action in actions) {
        if (action.method == method && state.contains(action.result.state)) {
          return true;
        }
      }
    }
    return false;
  }

  bool get isEmpty => actions.isEmpty;

  bool get isNotEmpty => actions.isNotEmpty;

  int get length =>
      isEmpty
          ? 0
          : actions.map((action) => action.length).reduce((value, element) => element + value);

  bool get hasError =>
      isEmpty
          ? false
          : actions
          .where((action) => action.result.state == BatchState.error)
          .length > 0;

  bool get hasInsertSuccess => containsMethodResult(BatchMethod.insert, [BatchState.success]);

  bool get hasInsertError => containsMethodResult(BatchMethod.insert, [BatchState.error]);

  bool get hasUpdateSuccess => containsMethodResult(BatchMethod.update, [BatchState.success]);

  bool get hasUpdateError => containsMethodResult(BatchMethod.update, [BatchState.error]);

  bool get hasDeleteSuccess => containsMethodResult(BatchMethod.delete, [BatchState.success]);

  bool get hasDeleteError => containsMethodResult(BatchMethod.delete, [BatchState.error]);

  int size(List<BatchMethod> methods, {BatchResult? result}) =>
      isEmpty
          ? 0
          : actions
          .where((action) {
        final exists = methods.contains(action.method);
        return (exists && result != null) ? action.result.state == result.state : exists;
      })
          .map((action) => action.length)
          .reduce((value, element) => element + value);

  List<BatchAction<T>> getActions({List<BatchMethod> methods = ALL_METHODS, BatchResult? result}) =>
      isEmpty
      ? []

      :

  actions.where

  (

  (

  action

  ) {
  final exists = methods.contains(action.method);
  return (exists && result != null) ? action.result.state == result.state : exists;
  })

      .

  toList();

  T? first({List<BatchMethod> methods = ALL_METHODS, BatchResult? result}) {
    for (var action in actions) {
      final exists = methods.contains(action.method);
      if ((exists && result != null) ? action.result.state == result.state : exists) {
        for (var data in action.collection) {
          return data;
        }
      }
    }
    return null;
  }

  List<T> data({List<BatchMethod> methods = ALL_METHODS, BatchResult? result}) =>
      isEmpty
      ? []

      :

  actions
      .where

  (

  (

  action

  ) {
  final exists = methods.contains(action.method);
  return (exists && result != null) ? action.result.state == result.state : exists;
  })

      .

  map

  (

  (

  action

  )

  =>

  action.collection

  )

      .

  reduce

  (

  (

  data

  ,

  collection

  ) {
  final List<T> result = [];
  if (data.isNotEmpty == true) {
  result.addAll(data);
  }
  result.addAll(collection);
  return result;
  });
}
