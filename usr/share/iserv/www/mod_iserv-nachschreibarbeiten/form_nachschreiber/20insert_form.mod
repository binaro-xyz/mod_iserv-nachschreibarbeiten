<h1>Nachschreiber_in eintragen</h1>
<?php
function is_collision($date, $student_act) {
    $query = 'SELECT
(SELECT COUNT(*) FROM exam_plan WHERE exam_plan.actgrp = ANY((SELECT array_agg(distinct members.actgrp) FROM members WHERE members.actuser=' . qdb($student_act) . ')::text[]) AND EXTRACT(WEEK FROM exam_plan.date) = EXTRACT(WEEK FROM TIMESTAMP ' . qdb($date) . ') AND EXTRACT(YEAR FROM exam_plan.date) = EXTRACT(YEAR FROM TIMESTAMP ' . qdb($date) . ')) AS week_count,
(SELECT COUNT(*) AS day_count FROM exam_plan WHERE exam_plan.actgrp = ANY((SELECT array_agg(distinct members.actgrp) FROM members WHERE members.actuser=' . qdb($student_act) . ')::text[]) AND exam_plan.date = ' . qdb($date) . ') AS day_count,
(SELECT COUNT(*) FROM mod_nachschreibarbeiten_entries WHERE student_act = ' . qdb($student_act) . ' AND mod_nachschreibarbeiten_entries.date_id = (SELECT mod_nachschreibarbeiten_dates.id FROM mod_nachschreibarbeiten_dates WHERE date=' . qdb($date) . ')) AS entry_count;';
    $conflicts = db_getRow($query);
    return $conflicts['day_count'] < 1 && $conflicts['week_count'] < 3 && $conflicts['entry_count'] < 1;
}

if(!empty($_POST['date'])) {
    $date = db_getRow('SELECT * FROM mod_nachschreibarbeiten_dates WHERE id=' . qdb($_POST['date']));
    if($_POST['warned'] != 'true' && !is_collision($date['date'], $_POST['student'])) {
        echo '<div class="warn" style="text-align: center; margin: 10px;">' . icon('dlg-warn') . '<strong>Achtung!</strong> Für die Schüler_in ' . ActToName($_POST['student']) . ' sind schon 3 Klausuren für diese Woche oder 1 Klausur an diesem Tag eingetragen!<br>
        <form method="post" action="#">
            <input type="hidden" name="date" value="' . strip_tags($_POST['date']) . '">
            <input type="hidden" name="student" value="' . strip_tags($_POST['student']) . '">
            <input type="hidden" name="student_class" value="' . strip_tags($_POST['student_class']) . '">
            <input type="hidden" name="subject" value="' . strip_tags($_POST['subject']) . '">
            <input type="hidden" name="additional_material" value="' . strip_tags($_POST['additional_material']) . '">
            <input type="hidden" name="duration" value="' . strip_tags($_POST['duration']) . '">
            <input type="hidden" name="teacher" value="' . strip_tags($_POST['teacher']) . '">
            <input type="hidden" name="warned" value="true">
            <input type="submit" value="Dennoch eintragen">
        </form>
        </div>';
    } else {
        $data = array(
            'date_id' => escape($_POST['date']),
            'student_act' => escape($_POST['student']),
            'class' => escape($_POST['student_class']),
            'subject' => escape($_POST['subject']),
            'additional_material' => escape($_POST['additional_material']),
            'duration' => escape($_POST['duration']),
            'teacher_act' => escape($_POST['teacher']),
            'created_by_act' => escape($_SESSION['act'])
        );

        require_once 'sec/login.inc';
        if(db_store('mod_nachschreibarbeiten_entries', $data)) {
            log_insert('Nachschreiber_in ' . ActToName($_POST['student']) . ' für Termin ' . strip_tags($date['date']) . ' hinzugefügt', null, 'Nachschreibarbeiten');
            Info('Nachschreiber_in erfolgreich eingetragen.');
        }
        else {
            Error('Fehler beim Eintragen der Nachschreiber_in.');
        }
    }
}


$sel_students = db_getHash(
  'SELECT u.act, user_join_name(u.firstname, u.lastname)
  FROM users u
  JOIN members m ON m.actuser = u.act
  JOIN groups_priv p ON p.act = m.actgrp
  WHERE u.deleted IS NULL
  AND p.privilege IN (\'exam_plan_do\')
  ORDER BY u.act'
);
$sel_teachers = db_getHash(
  'SELECT u.act, user_join_name(u.firstname, u.lastname)
   FROM users u
	 JOIN members m ON m.actuser = u.act
	 JOIN groups_priv p ON p.act = m.actgrp
   WHERE u.deleted IS NULL
	 AND p.privilege IN (\'mod_nachschreibarbeiten_access\', \'mod_nachschreibarbeiten_admin\')
   ORDER BY u.act'
);

$student_select = combo('student', '', $sel_students, array(), true);
$teacher_select = combo('teacher', '', $sel_teachers, array(), true);
$dates = db_getAll('SELECT * FROM mod_nachschreibarbeiten_dates WHERE date >= current_date ORDER BY date ASC');
?>

<form method="post" action="#">
<<?php echo $GLOBALS["padtbl"]; ?>>
  <tr><td>Datum:</td><td><select name="date">
              <?php
              foreach($dates as $date) {
                  echo '<option value="' . strip_tags($date['id']) . '">' . getLocalizedFormattedDate($date['date'], '%A') . ', den ' . getLocalizedFormattedDate($date['date'], '%d. %B %Y') . '</option>';
              }
              ?>
          </select></td></tr>
  <tr><td>Name der Schüler_in:</td><td><?php echo $student_select; ?></td></tr>
  <tr><td>Klasse:</td><td><input type="text" name="student_class"></td></tr> <!-- Note: Unfortunately, IServ doesn't know the class of a student -->
  <tr><td>Fach:</td><td><input type="text" name="subject"></td></tr>
  <tr><td>Zusatzmaterialien:</td><td><input type="text" name="additional_material"></td></tr>
  <tr><td>Dauer (in Minuten):</td><td><input type="number" name="duration" value="45"></td></tr>
  <tr><td>Lehrkraft:</td><td><?php echo $teacher_select; ?></td></tr>
</table>
    <input type="hidden" name="warned" value="false">
<input type="submit">
</form>
