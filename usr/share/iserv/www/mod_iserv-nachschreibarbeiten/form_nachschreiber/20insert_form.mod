<?php
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
$teacher_select = combo('teacher', '', $sel_teachers, array(), true)
?>

<h1>Nachschreiber_in eintragen</h1>
<form method="post" action="#">
<<?php echo $GLOBALS["padtbl"]; ?>>
  <tr><td>Datum:</td><td><select name="date"><option>01. Januar 1970</option></select></td></tr> <!-- TODO -->
  <tr><td>Name der Schüler_in:</td><td><?php echo $student_select; ?></td></tr> <!-- TODO -->
  <tr><td>Klasse:</td><td><input type="text" name="student_class"></td></tr> <!-- Note: Unfortunately, IServ doesn't know the class of a student -->
  <tr><td>Fach:</td><td><input type="text" name="subject"></td></tr>
  <tr><td>Zusatzmaterialien:</td><td><input type="text" name="additional_material"></td></tr>
  <tr><td>Dauer (in Minuten):</td><td><input type="number" name="duration"></td></tr>
  <tr><td>Lehrkraft:</td><td><?php echo $teacher_select; ?></td></tr>
</table>
<input type="submit">
</form>
