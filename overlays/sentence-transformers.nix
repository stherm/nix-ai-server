final: prev:

{
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (python-final: python-prev: {
      sentence-transformers = python-prev.sentence-transformers.overridePythonAttrs (oldAttrs: rec {
        version = "4.1.0";
        src = prev.fetchFromGitHub {
          owner = "UKPLab";
          repo = "sentence-transformers";
          tag = "v${version}";
          hash = "sha256-9Mg3+7Yxf195h4cUNLP/Z1PrauxanHJfS8OV2JIwRj4=";
        };
      });
    })
  ];
}
