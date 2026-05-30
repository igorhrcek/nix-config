final: prev: {
  python314 = prev.python314.override {
    packageOverrides = pyfinal: pyprev: {
      llm = pyprev.llm.overridePythonAttrs (old: {
        doCheck = false;
      });
    };
  };
  python314Packages = final.python314.pkgs;
}

