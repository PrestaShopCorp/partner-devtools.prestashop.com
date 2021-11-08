const fs = require('fs');
const archiver = require('archiver');
const path = require('path');

const main = async () => {
  const output = fs.createWriteStream(path.join(__dirname, '../rbm_example.zip'));
  const archive = archiver('zip', {
    zlib: { level: 9 } // Sets the compression level.
  });
  output.on('end', () => {
    console.log('Module rbm_example has been zipped');
  });
  archive.on('error', function(err) {
    console.error('Error', err);
    throw err;
  });

  archive.append(fs.createReadStream(path.join(__dirname, '../config.xml')), { name: 'rbm_example/config.xml' });
  archive.append(fs.createReadStream(path.join(__dirname, '../rbm_example.php')), { name: 'rbm_example/rbm_example.php' });
  archive.directory(path.join(__dirname, '../config'), 'rbm_example/config');
  archive.directory(path.join(__dirname, '../vendor'), 'rbm_example/vendor');
  archive.directory(path.join(__dirname, '../views'), 'rbm_example/views');


  archive.pipe(output);
  await archive.finalize();
}
main().then(() => {
  console.log('Module has been created');
  process.exit(0);
}).catch(error => {
  console.error(error);
  process.exit(1);
})