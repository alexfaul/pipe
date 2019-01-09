function firstlast_movie(path, n, pmt, varargin)
%SBXFIRSTLAST Make TIFFs of the first and last 500 frames

    p = inputParser;
    addOptional(p, 'type', 'sbx');  %sbx file type to open: sbx, sbxreg, xyreg, sbxclean, demonsreg
    addOptional(p, 'server', []);  % Server name
    addOptional(p, 'startframe', 1, @isnumeric);
    addOptional(p, 'optolevel', []);
    addOptional(p, 'estimate', false);  % Whether to give an estimate of where the path would be if it does not exist
    parse(p, varargin{:});
    p = p.Results;
    
    if nargin < 2, n = 500; end
    if nargin < 3, pmt = 1; end
    info = pipe.metadata(path);
    if isempty(p.optolevel)
        last_start = info.nframes - n + 1;
    else
        last_start = info.nframes - n*length(info.otwave) + p.optolevel;
    end
      
    
    spath = sprintf('%s_first-last-%i.tif', path(1:strfind(path,'.')-1), n);
    
    if ~exist(spath)
        f500 = pipe.imread(path, p.startframe, n, pmt, p.optolevel, 'register', true);
        l500 = pipe.imread(path, last_start, n, pmt, p.optolevel, 'register', true);

        pipe.io.write_tiff(cat(3, f500, l500), spath, class(f500));
    end
end

