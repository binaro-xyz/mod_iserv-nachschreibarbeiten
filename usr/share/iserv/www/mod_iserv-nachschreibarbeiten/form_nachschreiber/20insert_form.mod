<h1>Nachschreiber_in eintragen</h1>
<?php
require_once 'user.inc';
if(!empty($_POST['date'])) {
    $date = db_getRow('SELECT * FROM mod_nachschreibarbeiten_dates WHERE id=' . qdb($_POST['date']));
    if($_POST['warned'] != 'true' && !isCollision($date['date'], $_POST['student'])) {
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
        if($res = db_store('mod_nachschreibarbeiten_entries', $data)) {
            log_insert('Nachschreiber_in für Termin ' . $data['date_id'] . ' hinzugefügt: ' . ActToName($data['student_act']) . ', Klasse: ' . $data['class'] . ', Fach: "' . $data['subject'] . '", Zusatzmaterialien: "' . $data['additional_material'] . '", Dauer: ' . $data['duration'] . ' Minuten, Lehrkraft: ' . ActToName($data['teacher_act']), null, 'Nachschreibarbeiten');
            Info('Nachschreiber_in erfolgreich eingetragen.');

            mail(user_mail_addr($data['student_act']), 'Nachschreibtermin im Fach ' . $data['subject'] . ' eingetragen',
                "Ein neuer Nachschreibtermin wurde für Sie eingetragen.\r\n\r\nSie schreiben eine Arbeit im Fach {$data['subject']} nach. Die Nachschreibarbeit wird {$data['duration']} Minuten dauern." . (trim($data['additional_material']) == '' ? '' : ' Sie dürfen folgende Zusatzmaterialien verwenden: ' . $data['additional_material']) . "\r\nTermin: " . getLocalizedFormattedDate($date['date'], '%d. %B %Y') . ' um ' . getLocalizedFormattedDate($date['time'], '%H:%M') . " in Raum {$date['room']}, betreut von " . ActToName($date['teacher_act']) . "\r\n\r\n*Diese E-Mail wurde automatisch generiert*",
                "From: " . user_mail_addr() . "\r\nX-IServ-Module: Nachschreibarbeiten");
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

$student_select = combo('student', '', $sel_students, array('width' => '200px'), true);
$teacher_select = combo('teacher', '', $sel_teachers, array('width' => '200px'), true);
$dates = db_getAll('SELECT * FROM mod_nachschreibarbeiten_dates WHERE date >= current_date ORDER BY date ASC');
?>

<form method="post" action="#">
<<?php echo $GLOBALS["padtbl"]; ?>>
  <tr><td>Datum:</td><td><select name="date" style="width: 200px;">
              <?php
              foreach($dates as $date) {
                  echo '<option value="' . strip_tags($date['id']) . '">' . getLocalizedFormattedDate($date['date'], '%A') . ', den ' . getLocalizedFormattedDate($date['date'], '%d. %B %Y') . '</option>';
              }
              ?>
          </select></td></tr>
  <tr><td>Name der Schüler_in:</td><td><?php echo $student_select; ?></td></tr>
  <tr><td>Klasse:</td><td><input type="text" name="student_class" style="width: 200px;"></td></tr> <!-- Note: Unfortunately, IServ doesn't know the class of a student -->
  <tr><td>Fach:</td><td><input type="text" name="subject" style="width: 200px;"></td></tr>
  <tr><td>Zusatzmaterialien:</td><td><input type="text" name="additional_material" style="width: 200px;"></td></tr>
  <tr><td>Dauer (in Minuten):</td><td><input type="number" name="duration" value="45" style="width: 200px;"></td></tr>
  <tr><td>Lehrkraft:</td><td><?php echo $teacher_select; ?></td></tr>
</table>
    <input type="hidden" name="warned" value="false">
<input type="submit">
</form>
