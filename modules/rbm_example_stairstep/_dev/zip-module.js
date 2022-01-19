const fs = require('fs');
const archiver = require('archiver');
const path = require('path');

const main = async () => {
  const output = fs.createWriteStream(path.join(__dirname, '../rbm_example_stairstep.zip'));
  const archive = archiver('zip', {
    zlib: { level: 9 } // Sets the compression level.
  });
  output.on('end', () => {
    console.log('Module rbm_example_stairstep has been zipped');
  });
  archive.on('error', function(err) {
    console.error('Error', err);
    throw err;
  });

  archive.append(fs.createReadStream(path.join(__dirname, '../config.xml')), { name: 'rbm_example_stairstep/config.xml' });
  archive.append(fs.createReadStream(path.join(__dirname, '../rbm_example_stairstep.php')), { name: 'rbm_example_stairstep/rbm_example_stairstep.php' });
  archive.directory(path.join(__dirname, '../config'), 'rbm_example_stairstep/config');
  archive.directory(path.join(__dirname, '../vendor'), 'rbm_example_stairstep/vendor');
  archive.directory(path.join(__dirname, '../views'), 'rbm_example_stairstep/views');


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