import 'package:flutter_utils/id/identifiable.dart';
import 'package:rxdart/rxdart.dart';

import 'batch_data.dart';

/// Created by @RealCradle on 2021/7/25
///

mixin BatchAware<T extends Identifiable> {
  final BehaviorSubject<Map<String, T>> _subject = BehaviorSubject.seeded(<String, T>{});

  Stream<Map<String, T>> get observableData => _subject.stream;

  void processBatchData(BatchData<T> batchData) async {
    for (var action in batchData.getActions()) {
      switch (action.method) {
        case BatchMethod.insert:
        case BatchMethod.update:
        case BatchMethod.select:
          final changedData = Map<String, T>.from(_subject.value ?? {});
          action.collection.forEach((entity) {
            changedData[entity.id] = entity;
          });
          _subject.add(changedData);
          break;
        case BatchMethod.delete:
          final changedData = Map<String, T>.from(_subject.value ?? {});
          bool changed = false;
          action.collection.forEach((entity) {
            if (changedData.containsKey(entity.id)) {
              changedData.remove(entity.id);
              changed = true;
            }
          });
          if (changed) {
            _subject.add(changedData);
          }
          break;
        case BatchMethod.clear:
          _subject.add(Map<String, T>());
          break;
        default:
          break;
      }
    }
  }

  void disposeBatch() {
    _subject.close();
  }
}
