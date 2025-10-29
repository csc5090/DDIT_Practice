const apiClient = axios.create({
    baseURL: CONTEXT_PATH, 
    timeout: 10000,
    headers: { 'Content-Type': 'application/json' }
});

apiClient.interceptors.response.use(
    (response) => response.data,
    (error) => {
        console.error('API Error:', error);
        Swal.fire({
            icon: 'error',
            title: '요청 실패',
            text: error.response?.data?.message || '서버와 통신 중 문제가 발생했습니다.',
        });
        return Promise.reject(error);
    }
);