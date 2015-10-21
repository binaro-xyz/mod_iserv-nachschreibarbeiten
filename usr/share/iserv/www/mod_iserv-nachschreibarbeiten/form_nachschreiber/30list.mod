<?php
$dates = db_getAll('SELECT * FROM mod_nachschreibarbeiten_dates WHERE date >= current_date ORDER BY date ASC');
?>

<h1>Nachschreiber_innen</h1>

<?php
foreach($dates as $date) {
    $entries = db_getAll('SELECT * FROM mod_nachschreibarbeiten_entries WHERE date_id = ' . qdb($date['id']));
    if(count($entries) > 0) {
        echo '<h2>' . getLocalizedFormattedDate($date['date'], '%A') . ', den ' . getLocalizedFormattedDate($date['date'], '%d. %B %Y') . '</h2>';
        echo '<p>Uhrzeit: ' . getLocalizedFormattedDate($date['time'], '%H:%M') . ', Raum: ' . $date['room'] . ', Betreuer_in: ' . ActToName($date['teacher_act']) . '</p>';
        ?>
        <table>
            <thead>
            <td style="width: 150px;">Name der Schüler_in</td>
            <td style="width: 100px;">Klasse</td>
            <td style="width: 125px;">Fach</td>
            <td style="width: 250px;">Zusatzmaterialien</td>
            <td style="width: 130px;">Dauer (in Minuten)</td>
            <td style="width: 150px;">Lehrkraft</td>
            <td></td>
            </thead>
            <tbody>
                <?php
                foreach ($entries as $entry) {
                    echo '<tr><td>' . ActToName($entry['student_act']) . '</td><td>' . strip_tags($entry['class']) . '</td><td>' . strip_tags($entry['subject']) . '</td><td>' . strip_tags($entry['additional_material']) . '</td><td>' . strip_tags($entry['duration']) . '</td><td>' . ActToName($entry['teacher_act']) . '</td><td>' . (userCanEdit($entry) ? popup('edit.php?type=entry&id=' . $entry['id'], 415, 325, icon('manage')) : '') . '</td></tr>';
                }
                ?>
            </tbody>
        </table>
        <?php
    }
}
