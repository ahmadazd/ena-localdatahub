#!/usr/bin/env python3

# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
__author__ = "Ahmad Zyoud"

import os,sys
import subprocess

class FetchingReadFiles:

    def __init__(self, df, fileType, outdir):
        self.df = df
        self.fileType = fileType
        self.outdir = outdir

    def mkdir(self):
        if not os.path.exists(self.outdir):
            os.mkdir(self.outdir)

    def API_call(self, url):
        command = f'lftp -c "open ftp://ftp.sra.ebi.ac.uk; get {url.strip("ftp.sra.ebi.ac.uk")} -o {os.path.abspath(self.outdir)}"'
        print(command)
        sp = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        out, err = sp.communicate()
        sys.stderr.write(out.decode())
        sys.stderr.write(err.decode())
        stdoutOrigin = sys.stdout

    def fetching_readsFiles(self):
        print('Pulling public reads...................................................................')
        self.mkdir()
        for url in self.df[f'{self.fileType.lower()}_ftp']:
            url_file = url.split(';')
            if url == f'{self.fileType.lower()}_ftp':
                continue
            self.API_call(url_file[0])
            if url_file[1]:
                self.API_call(url_file[1])