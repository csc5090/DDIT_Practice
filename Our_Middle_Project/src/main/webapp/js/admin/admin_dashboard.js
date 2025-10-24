document.addEventListener('DOMContentLoaded', () => {
    
    const ctx = document.getElementById('monthlyUsersChart').getContext('2d');
    const sampleData = {
        labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
        values: [1200, 1900, 3000, 5000, 2300, 3200]
    };

    new Chart(ctx, {
        type: 'line',
        data: {
            labels: sampleData.labels,
            datasets: [{
                label: '월간 활성 사용자',
                data: sampleData.values,
                backgroundColor: 'rgba(52, 211, 153, 0.2)',
                borderColor: 'rgba(52, 211, 153, 1)',
                borderWidth: 2,
                tension: 0.4,
                fill: true
            }]
        },
        options: {
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: { color: 'var(--text-muted)' },
                    grid: { color: 'rgba(255, 255, 255, 0.1)' }
                },
                x: {
                    ticks: { color: 'var(--text-muted)' },
                    grid: { color: 'rgba(255, 255, 255, 0.1)' }
                }
            },
            plugins: {
                legend: {
                    labels: { color: 'var(--text-light)' }
                }
            }
        }
    });

});