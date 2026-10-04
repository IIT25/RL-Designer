/** @type {import('next').NextConfig} */
const backendUrl = process.env.BACKEND_URL;
console.log(backendUrl);

const nextConfig = {
  experimental: {
    proxyTimeout: 120000,
  },
  rewrites: async () => {
    return [
      {
        source: '/api/:path*',
        destination: backendUrl
          ? `${backendUrl}/:path*`
          : process.env.NODE_ENV === 'development'
            ? 'http://127.0.0.1:5328/api/:path*'
            : '/api/',
      },
    ];
  },
};
module.exports = nextConfig;