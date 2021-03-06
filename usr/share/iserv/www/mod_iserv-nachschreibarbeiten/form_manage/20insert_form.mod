<h1>Nachschreibtermin eintragen</h1>

<?php
$sel_teachers = db_getHash(
  'SELECT u.act, user_join_name(u.firstname, u.lastname)
   FROM users u
	 JOIN members m ON m.actuser = u.act
	 JOIN groups_priv p ON p.act = m.actgrp
   WHERE u.deleted IS NULL
	 AND p.privilege IN (\'mod_nachschreibarbeiten_access\', \'mod_nachschreibarbeiten_admin\')
   ORDER BY u.act'
);
$teacher_select = combo('teacher', $_SESSION['act'], $sel_teachers, array('width' => '200px'), true);
?>

<form method="post" action="#">
	<<?php echo $GLOBALS["padtbl"]; ?>>
	<!-- Ugh. Srsly? Using 'd.m.o' as a date format *interally*? Wow. -->
	<tr><td>Datum:</td><td><input type="text" name="date" class="date" value="<?php echo date('d.m.o', strtotime('next friday')); ?>" style="width: 200px;"></td></tr>
	<tr><td>Uhrzeit:</td><td><input type="time" name="time" value="14:00" style="width: 200px;"></td></tr>
	<tr><td>Raum:</td><td><input type="text" name="room" value="151" style="width: 200px;"></td></tr>
	<tr><td>Betreuer_in:</td><td><?php echo $teacher_select; ?></td></tr>
	</table>
    <input type="submit">
</form>
