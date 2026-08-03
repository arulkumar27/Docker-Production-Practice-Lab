CREATE TABLE IF NOT EXISTS practice_tasks (
    id BIGSERIAL PRIMARY KEY,
    task_name VARCHAR(150) NOT NULL,
    task_status VARCHAR(30) NOT NULL DEFAULT 'pending',
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO practice_tasks (task_name, task_status)
VALUES
    ('Learn Docker Compose', 'completed'),
    ('Practise health checks', 'in_progress'),
    ('Understand service dependencies', 'pending');
