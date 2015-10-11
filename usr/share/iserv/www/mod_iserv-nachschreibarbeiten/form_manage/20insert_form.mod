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
$teacher_select = combo('teacher', $_SESSION['act'], $sel_teachers, array('width' => '144px'), true);
?>

<form method="post" action="#">
	<<?php echo $GLOBALS["padtbl"]; ?>>
	<tr><td>Datum:</td><td><input type="date" name="date" value="<?php echo date('o-m-d'); ?>" style="width: 144px;"></td></tr> <!-- TODO: Automatically pick the next Friday -->
	<tr><td>Uhrzeit:</td><td><input type="time" name="time" value="14:00" style="width: 144px;"></td></tr>
	<tr><td>Raum:</td><td><input type="text" name="room" value="151"></td></tr>
	<tr><td>Betreuer:</td><td><?php echo $teacher_select; ?></td></tr>
	</table>
    <input type="submit">
</form>
