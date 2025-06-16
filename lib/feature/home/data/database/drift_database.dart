import 'dart:io';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'drift_database.g.dart';

class TodoItem extends Table{
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min:5)();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(Constant(DateTime.now()))();
}

LazyDatabase _openConnection(Directory dbDir,Directory tempFolder,String sqliteFileName){
  return LazyDatabase(()async{
    final file = File(p.join(dbDir.path,sqliteFileName));
    if(Platform.isAndroid){
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    final cachebase = tempFolder.path;
    sqlite3.tempDirectory = cachebase;
    return NativeDatabase.createBackgroundConnection(file,setup: (rawDb){
      rawDb.execute("PRAGMA journal_mode=WAL;");
      rawDb.execute("PRAGMA busy_timeout=100;");
    });
  });
}

@DriftDatabase(tables:[TodoItem])
class AppDatabase extends _$AppDatabase{
  final Directory dbDir;
  final Directory tempFolder;
  final String sqliteFileName;

  AppDatabase({
    required this.dbDir,
    required this.sqliteFileName,
    required this.tempFolder
  }):super(_openConnection(dbDir,tempFolder,sqliteFileName));

  @override 
  int get schemaVersion =>1;
}

