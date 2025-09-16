-- Sample Queries for Embroidery Production Management System
-- Contains example data insertion and common queries for production tracking and salary calculations

-- ===========================================
-- SAMPLE DATA INSERTION
-- ===========================================

-- Insert sample salary rates
INSERT INTO salary_rates (design_type, base_rate, bonus_rate, quality_threshold, effective_from) VALUES
('Basic Embroidery', 2.50, 0.50, 7.0, '2024-01-01'),
('Complex Design', 5.00, 1.00, 8.0, '2024-01-01'),
('Logo Embroidery', 3.00, 0.75, 7.5, '2024-01-01'),
('Custom Pattern', 4.00, 0.80, 8.0, '2024-01-01'),
('Machine Embroidery', 1.50, 0.25, 6.5, '2024-01-01');

-- Insert sample workers
INSERT INTO workers (worker_name, employee_id, phone_number, hire_date) VALUES
('Ahmed Ali', 'EMP001', '+92-300-1234567', '2023-06-01'),
('Fatima Khan', 'EMP002', '+92-301-2345678', '2023-07-15'),
('Muhammad Hassan', 'EMP003', '+92-302-3456789', '2023-08-01'),
('Aisha Malik', 'EMP004', '+92-303-4567890', '2023-09-01'),
('Omar Farooq', 'EMP005', '+92-304-5678901', '2023-10-01');

-- Insert sample production entries
INSERT INTO production_entries (worker_name, date, shift, design_type, pieces_completed, rate_per_piece, quality_score, remarks) VALUES
-- Ahmed Ali's work
('Ahmed Ali', '2024-09-01', 'Day', 'Basic Embroidery', 25, 2.50, 8.5, 'Good quality work'),
('Ahmed Ali', '2024-09-02', 'Day', 'Complex Design', 15, 5.00, 9.0, 'Excellent attention to detail'),
('Ahmed Ali', '2024-09-03', 'Day', 'Logo Embroidery', 20, 3.00, 8.0, 'Consistent performance'),

-- Fatima Khan's work
('Fatima Khan', '2024-09-01', 'Evening', 'Custom Pattern', 18, 4.00, 8.5, 'Very creative approach'),
('Fatima Khan', '2024-09-02', 'Evening', 'Basic Embroidery', 30, 2.50, 7.5, 'Fast and accurate'),
('Fatima Khan', '2024-09-03', 'Evening', 'Machine Embroidery', 40, 1.50, 7.0, 'Met quality standards'),

-- Muhammad Hassan's work
('Muhammad Hassan', '2024-09-01', 'Day', 'Complex Design', 12, 5.00, 9.5, 'Outstanding craftsmanship'),
('Muhammad Hassan', '2024-09-02', 'Day', 'Logo Embroidery', 22, 3.00, 8.2, 'Precise work'),
('Muhammad Hassan', '2024-09-03', 'Day', 'Custom Pattern', 16, 4.00, 8.8, 'High quality finish'),

-- Aisha Malik's work
('Aisha Malik', '2024-09-01', 'Night', 'Machine Embroidery', 35, 1.50, 6.8, 'Good speed'),
('Aisha Malik', '2024-09-02', 'Night', 'Basic Embroidery', 28, 2.50, 7.8, 'Reliable worker'),
('Aisha Malik', '2024-09-03', 'Night', 'Logo Embroidery', 19, 3.00, 7.6, 'Steady improvement'),

-- Omar Farooq's work
('Omar Farooq', '2024-09-01', 'Day', 'Basic Embroidery', 32, 2.50, 7.2, 'Fast worker'),
('Omar Farooq', '2024-09-02', 'Day', 'Custom Pattern', 14, 4.00, 8.3, 'Good technique'),
('Omar Farooq', '2024-09-03', 'Day', 'Complex Design', 10, 5.00, 9.2, 'Exceptional detail work');

-- ===========================================
-- COMMON QUERIES FOR PRODUCTION TRACKING
-- ===========================================

-- 1. Daily production summary
SELECT * FROM daily_production_summary 
WHERE date >= '2024-09-01' AND date <= '2024-09-03'
ORDER BY date;

-- 2. Worker performance overview
SELECT * FROM worker_performance
ORDER BY total_earnings DESC;

-- 3. Top performers by total pieces completed
SELECT 
    worker_name,
    SUM(pieces_completed) as total_pieces,
    AVG(quality_score) as avg_quality,
    SUM(total_amount) as total_earnings
FROM production_entries 
WHERE date >= '2024-09-01'
GROUP BY worker_name
ORDER BY total_pieces DESC;

-- 4. Quality-based performance analysis
SELECT 
    worker_name,
    COUNT(*) as entries_count,
    AVG(quality_score) as avg_quality,
    COUNT(CASE WHEN quality_score >= 8.0 THEN 1 END) as high_quality_count,
    CAST(COUNT(CASE WHEN quality_score >= 8.0 THEN 1 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) as high_quality_percentage
FROM production_entries
GROUP BY worker_name
ORDER BY avg_quality DESC;

-- ===========================================
-- SALARY CALCULATION QUERIES
-- ===========================================

-- 5. Calculate salary with bonus for quality work
SELECT 
    pe.worker_name,
    pe.date,
    pe.design_type,
    pe.pieces_completed,
    pe.quality_score,
    sr.base_rate,
    sr.bonus_rate,
    sr.quality_threshold,
    -- Base payment
    (pe.pieces_completed * sr.base_rate) as base_payment,
    -- Bonus payment (if quality score meets threshold)
    CASE 
        WHEN pe.quality_score >= sr.quality_threshold 
        THEN (pe.pieces_completed * sr.bonus_rate)
        ELSE 0
    END as bonus_payment,
    -- Total daily payment
    (pe.pieces_completed * sr.base_rate) + 
    CASE 
        WHEN pe.quality_score >= sr.quality_threshold 
        THEN (pe.pieces_completed * sr.bonus_rate)
        ELSE 0
    END as total_daily_payment
FROM production_entries pe
JOIN salary_rates sr ON pe.design_type = sr.design_type AND sr.is_active = 1
WHERE pe.date >= '2024-09-01'
ORDER BY pe.worker_name, pe.date;

-- 6. Weekly salary summary by worker
SELECT 
    pe.worker_name,
    COUNT(*) as days_worked,
    SUM(pe.pieces_completed) as total_pieces,
    AVG(pe.quality_score) as avg_quality_score,
    -- Total base salary
    SUM(pe.pieces_completed * sr.base_rate) as total_base_salary,
    -- Total bonus earned
    SUM(
        CASE 
            WHEN pe.quality_score >= sr.quality_threshold 
            THEN (pe.pieces_completed * sr.bonus_rate)
            ELSE 0
        END
    ) as total_bonus,
    -- Grand total
    SUM(pe.pieces_completed * sr.base_rate) + 
    SUM(
        CASE 
            WHEN pe.quality_score >= sr.quality_threshold 
            THEN (pe.pieces_completed * sr.bonus_rate)
            ELSE 0
        END
    ) as total_weekly_salary
FROM production_entries pe
JOIN salary_rates sr ON pe.design_type = sr.design_type AND sr.is_active = 1
WHERE pe.date >= '2024-09-01' AND pe.date <= '2024-09-03'
GROUP BY pe.worker_name
ORDER BY total_weekly_salary DESC;

-- 7. Design type profitability analysis
SELECT 
    pe.design_type,
    COUNT(*) as total_orders,
    SUM(pe.pieces_completed) as total_pieces_produced,
    AVG(pe.quality_score) as avg_quality_score,
    AVG(sr.base_rate) as avg_base_rate,
    SUM(pe.pieces_completed * sr.base_rate) as total_base_cost,
    SUM(
        CASE 
            WHEN pe.quality_score >= sr.quality_threshold 
            THEN (pe.pieces_completed * sr.bonus_rate)
            ELSE 0
        END
    ) as total_bonus_cost,
    SUM(pe.pieces_completed * sr.base_rate) + 
    SUM(
        CASE 
            WHEN pe.quality_score >= sr.quality_threshold 
            THEN (pe.pieces_completed * sr.bonus_rate)
            ELSE 0
        END
    ) as total_production_cost
FROM production_entries pe
JOIN salary_rates sr ON pe.design_type = sr.design_type AND sr.is_active = 1
WHERE pe.date >= '2024-09-01'
GROUP BY pe.design_type, sr.base_rate
ORDER BY total_production_cost DESC;

-- 8. Monthly attendance and productivity report
SELECT 
    pe.worker_name,
    COUNT(DISTINCT pe.date) as days_present,
    SUM(pe.pieces_completed) as total_monthly_pieces,
    CAST(AVG(CAST(pe.pieces_completed AS FLOAT)) AS DECIMAL(10,2)) as avg_daily_pieces,
    AVG(pe.quality_score) as avg_monthly_quality,
    SUM(
        (pe.pieces_completed * sr.base_rate) + 
        CASE 
            WHEN pe.quality_score >= sr.quality_threshold 
            THEN (pe.pieces_completed * sr.bonus_rate)
            ELSE 0
        END
    ) as total_monthly_earnings
FROM production_entries pe
JOIN salary_rates sr ON pe.design_type = sr.design_type AND sr.is_active = 1
WHERE MONTH(pe.date) = 9 AND YEAR(pe.date) = 2024
GROUP BY pe.worker_name
ORDER BY total_monthly_earnings DESC;

-- 9. Shift performance comparison
SELECT 
    pe.shift,
    COUNT(*) as total_entries,
    COUNT(DISTINCT pe.worker_name) as workers_count,
    SUM(pe.pieces_completed) as total_pieces,
    AVG(CAST(pe.pieces_completed AS FLOAT)) as avg_pieces_per_entry,
    AVG(pe.quality_score) as avg_quality_score,
    SUM(
        (pe.pieces_completed * sr.base_rate) + 
        CASE 
            WHEN pe.quality_score >= sr.quality_threshold 
            THEN (pe.pieces_completed * sr.bonus_rate)
            ELSE 0
        END
    ) as total_shift_cost
FROM production_entries pe
JOIN salary_rates sr ON pe.design_type = sr.design_type AND sr.is_active = 1
WHERE pe.date >= '2024-09-01'
GROUP BY pe.shift
ORDER BY total_shift_cost DESC;

-- 10. Bonus eligibility report
SELECT 
    pe.worker_name,
    pe.date,
    pe.design_type,
    pe.pieces_completed,
    pe.quality_score,
    sr.quality_threshold,
    CASE 
        WHEN pe.quality_score >= sr.quality_threshold 
        THEN 'Eligible' 
        ELSE 'Not Eligible' 
    END as bonus_eligibility,
    CASE 
        WHEN pe.quality_score >= sr.quality_threshold 
        THEN (pe.pieces_completed * sr.bonus_rate)
        ELSE 0
    END as bonus_amount
FROM production_entries pe
JOIN salary_rates sr ON pe.design_type = sr.design_type AND sr.is_active = 1
WHERE pe.date >= '2024-09-01'
ORDER BY pe.worker_name, pe.date;

GO