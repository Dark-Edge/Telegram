CREATE TABLE mailboxes (
    char_identifier VARCHAR(255),
	steamname VARCHAR(255),
    mailbox_id INT AUTO_INCREMENT PRIMARY KEY,
	Animation INT(11) NOT NULL DEFAULT 0,
    first_name VARCHAR(255),
    last_name VARCHAR(255)
);

CREATE TABLE mailbox_messages (
    from_char VARCHAR(255),
    to_char VARCHAR(255),
    message TEXT,
    subject VARCHAR(255),
    location VARCHAR(255),
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    id INT AUTO_INCREMENT PRIMARY KEY,
    eta_timestamp BIGINT
);

INSERT INTO `items` (`item`, `label`, `limit`, `can_remove`, `type`, `usable`) VALUES
('Mail', 'Lettre', 99, 1, 'item_standard', 1);

INSERT INTO `items` (`item`, `label`, `limit`, `can_remove`, `type`, `usable`) VALUES
('BoxTicket', 'Ticket de boite mail', 1, 1, 'item_standard', 1);

INSERT INTO `items` (`item`, `label`, `limit`, `can_remove`, `type`, `usable`) VALUES
('Hibou', 'Hibou Postal', 10, 1, 'item_standard', 1);

INSERT INTO `items` (`item`, `label`, `limit`, `can_remove`, `type`, `usable`) VALUES
('Pigeon', 'Pigeon Postal', 10, 1, 'item_standard', 1);