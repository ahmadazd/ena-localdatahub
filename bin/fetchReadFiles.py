#!/usr/bin/env python3

# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
__author__ = "Ahmad Zyoud"

import os,sys
import subprocess
import pandas as pd

class FetchingReadFiles:

    def __init__(self, fileType, outdir, run_id, sample_id, logs, url = None, df=None):
        self.df = df
        self.fileType = fileType
        self.outdir = outdir
        self.url = url
        self.run_id =run_id
        self.sample_id = sample_id
        self.logs =logs

    def mkdir(self):
        if not os.path.exists(self.outdir):
            os.mkdir(self.outdir)

    def API_call(self,url=None):
        if url is not None:
            self.url = url
        for sub_url in self.url.split(';'):
            command = f'lftp -c "open ftp://ftp.sra.ebi.ac.uk; get {sub_url.strip("ftp.sra.ebi.ac.uk")} -o ' \
                      f'{os.path.abspath(self.outdir)}"'
            print(command)
            sp = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            out, err = sp.communicate()
            sys.stderr.write(out.decode())
            sys.stderr.write(err.decode())
            stdoutOrigin = sys.stdout
            file_name = sub_url.split('/')
            if not err:
                if os.path.exists(f"{os.path.abspath(self.outdir)}/{file_name[6]}"):
                    if os.path.exists(f"{self.logs}/fetchedFiles_metadata.txt"):
                        header = False
                    else:
                        header = True

                    metadata_logs = {'run_accession': [self.run_id], 'sample_id': [self.sample_id],
                                     'file_name': [file_name[6]]}
                    metadata_logs_df = pd.DataFrame.from_dict(metadata_logs)
                    metadata_logs_df.to_csv(f"{self.logs}/fetchedFiles_metadata.txt", mode ="a", index = False,
                                            header = header)


    def fetching_readsFiles(self):
        sys.stdout.write('Pulling public reads...................................................................')
        #self.mkdir()
        if self.df is not None and self.url is None :
            for url in self.df[f'{self.fileType.lower()}_ftp']:
                url_file = url.split(';')
                if url == f'{self.fileType.lower()}_ftp':
                    continue
                self.API_call(url_file[0])
                try:
                    if url_file[1]:
                        self.API_call(url_file[1])
                except IndexError:
                    continue
        elif self.df is None and self.url is not None:
           self.API_call()
        else:
            sys.stdout.write("One parameter only allowed either using a file or including the ftp url directly not both")
            exit(1)