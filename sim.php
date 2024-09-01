<?php

declare(strict_types=1);

require_once './const.php';

class Sim
{
    /**
     * @var object connect
     */
    public object $connect;

    public function __construct()
    {
        try {
            $this->connect = new PDO(
                DB_CONFIG,
                DB_LOGIN,
                DB_PASSWORD,
                [PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC]
            );
        } catch (\PDOException $e) {
            echo $e->getMessage();
            return;
        }
    }

    /**
     * @param array $request
     * @return void
     */
    public function create(array $request): void
    {
        $simFrom = $this->findByPart($request['simid_from']);
        $simTo = $this->findByPart($request['simid_from']);

        if (!$simFrom || !$simTo) {
            echo "Exception: Ошибка данных";
            exit();
        }

        try {
            $this->connect->beginTransaction();

            $state = $this->connect->prepare("INSERT INTO sim_balance_away(id, amount, iccid, comment)
            values(null, :amount, :iccid, :comment)");
            $state->execute([
                'amount' => $request['amount'],
                'iccid' => $request['simid_from'],
                'comment' => $request['comment'],
            ]);

            $state = $this->connect->prepare("INSERT INTO sim_balance_come(id, amount, iccid, comment)
            values(null, :amount, :iccid, :comment)");
            $state->execute([
                'amount' => $request['amount'],
                'iccid' => $request['simid_to'],
                'comment' => $request['comment'],
            ]);

        } catch (PDOException $e) {
            $this->connect->rollBack();
            echo `PDOException: {$e->getCode()} | {$e->getMessage()}`;
            exit();
        }
        $this->connect->commit();
    }

    public function findByPart(string $value): array|bool
    {
        $state = $this->connect->prepare("SELECT * FROM sim WHERE RIGHT(iccid, 6) = :simid");
        $state->execute([
            'simid' => $value,
        ]);
        return $state->fetch(PDO::FETCH_ASSOC);
    }
}