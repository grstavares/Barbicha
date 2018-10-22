import { AgmModule } from './agm.module';

describe('AgmModule', () => {
  let agmModule: AgmModule;

  beforeEach(() => {
    agmModule = new AgmModule();
  });

  it('should create an instance', () => {
    expect(agmModule).toBeTruthy();
  });
});
