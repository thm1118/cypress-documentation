/* eslint-disable */

console.log('');
console.log('');
console.log('---------------------------------------------');
console.log('  手动配置以下文件的服务器配置 ');
console.log('  ./deploy/config.js');
console.log('  ./deploy/index.js');
console.log('');
console.log('  文档: https://www.npmjs.com/package/ssh-deploy-release ');
console.log('---------------------------------------------');
console.log('');
console.log('');

const Application = require('ssh-deploy-release');
const options = require('./config.js')

const deployer = new Application(options);

console.log()
console.log('部署到 ' + options.host + ' 的路径是： ' + options.deployPath)
console.log()

deployer.rollbackToPreviousRelease(() => {
  console.log('回滚成功 !')
});
