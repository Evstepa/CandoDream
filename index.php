<?php

declare(strict_types=1);

libxml_use_internal_errors(true);

require_once './sim.php';

$action = new Sim();
var_dump($action);

if (
  isset($_POST['simid_from'])
  && isset($_POST['simid_to'])
  && isset($_POST['amount'])
) {
    $request = [
        'id' => null,
        'simid_from' => $_POST['simid_from'],
        'simid_to' => $_POST['simid_to'],
        'amount' => $_POST['amount'],
        'comment' => $_POST['comment'] ?? $_POST['comment'],
    ];
    $action->create($request);
};

$action->create($request);