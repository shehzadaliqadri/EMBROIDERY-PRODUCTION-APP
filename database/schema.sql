-- Embroidery Production Management Database Schema
-- Created for tracking production entries and salary calculations

-- Create database (uncomment if needed)
-- CREATE DATABASE embroidery_production;
-- USE embroidery_production;

-- Production entries table - tracks daily production data
CREATE TABLE production_entries (
    id INT PRIMARY KEY IDENTITY(1,1),
    worker_name NVARCHAR(100) NOT NULL,
    date DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    shift NVARCHAR(20) NOT NULL DEFAULT 'Day', -- Day, Night, Evening
    design_type NVARCHAR(50) NOT NULL,
    pieces_completed INT NOT NULL CHECK (pieces_completed >= 0),
    rate_per_piece DECIMAL(10,2) NOT NULL CHECK (rate_per_piece >= 0),
    total_amount AS (pieces_completed * rate_per_piece) PERSISTED,
    quality_score DECIMAL(3,1) CHECK (quality_score BETWEEN 0 AND 10),
    remarks NVARCHAR(500),
    created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME2 NOT NULL DEFAULT GETDATE()
);

-- Salary rates table - defines payment rates for different design types
CREATE TABLE salary_rates (
    id INT PRIMARY KEY IDENTITY(1,1),
    design_type NVARCHAR(50) NOT NULL UNIQUE,
    base_rate DECIMAL(10,2) NOT NULL CHECK (base_rate >= 0),
    bonus_rate DECIMAL(10,2) DEFAULT 0 CHECK (bonus_rate >= 0),
    quality_threshold DECIMAL(3,1) DEFAULT 7.0 CHECK (quality_threshold BETWEEN 0 AND 10),
    effective_from DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    effective_to DATE NULL,
    is_active BIT NOT NULL DEFAULT 1,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME2 NOT NULL DEFAULT GETDATE()
);

-- Workers table - basic worker information
CREATE TABLE workers (
    id INT PRIMARY KEY IDENTITY(1,1),
    worker_name NVARCHAR(100) NOT NULL UNIQUE,
    employee_id NVARCHAR(20),
    phone_number NVARCHAR(20),
    hire_date DATE,
    is_active BIT NOT NULL DEFAULT 1,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME2 NOT NULL DEFAULT GETDATE()
);

-- Create indexes for better performance
CREATE INDEX IX_production_entries_worker_date ON production_entries(worker_name, date);
CREATE INDEX IX_production_entries_date ON production_entries(date);
CREATE INDEX IX_production_entries_design_type ON production_entries(design_type);
CREATE INDEX IX_salary_rates_design_type ON salary_rates(design_type, is_active);

-- Create a view for daily production summary
CREATE VIEW daily_production_summary AS
SELECT 
    date,
    COUNT(*) as total_entries,
    COUNT(DISTINCT worker_name) as active_workers,
    SUM(pieces_completed) as total_pieces,
    AVG(CAST(pieces_completed AS FLOAT)) as avg_pieces_per_worker,
    SUM(total_amount) as total_production_value,
    AVG(quality_score) as avg_quality_score
FROM production_entries
GROUP BY date;

-- Create a view for worker performance
CREATE VIEW worker_performance AS
SELECT 
    worker_name,
    COUNT(*) as total_days_worked,
    SUM(pieces_completed) as total_pieces,
    AVG(CAST(pieces_completed AS FLOAT)) as avg_daily_pieces,
    SUM(total_amount) as total_earnings,
    AVG(total_amount) as avg_daily_earnings,
    AVG(quality_score) as avg_quality_score,
    MAX(date) as last_work_date
FROM production_entries
GROUP BY worker_name;

GO