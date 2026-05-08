
from fastapi import APIRouter, Depends, HTTPException
from typing import List, Optional
from app.models import HospitalCreate, HospitalResponse
from app.services.firestore_service import FirestoreService
from app.config import get_db

#prefix so all URLs start with /hospitals.
router = APIRouter(prefix="/hospitals", tags=["hospitals"])

#Injects the database service into our route handlers.
def get_service(db=Depends(get_db)):
    return FirestoreService(db)

@router.post("/", response_model=HospitalResponse)
async def create_hospital(hospital: HospitalCreate, service: FirestoreService = Depends(get_service)):
    """
   r: ManageHospitalsScreen (Registration Form).s: `FirestoreService.add_hospital` -> 'hospitals' collection.
    """
    hospital_id = await service.add_hospital(hospital.dict())
    return {**hospital.dict(), "id": hospital_id}

@router.put("/{hospital_id}")
async def update_hospital(hospital_id: str, hospital: HospitalCreate, service: FirestoreService = Depends(get_service)):
    """
    r: ManageHospitalsScreen (Edit Mode). s: `FirestoreService.update_hospital`.
    """
    await service.update_hospital(hospital_id, hospital.dict())
    return {"message": "Hospital updated successfully"}

@router.delete("/{hospital_id}")
async def delete_hospital(hospital_id: str, service: FirestoreService = Depends(get_service)):
    """
    r: ManageHospitalsScreen (Delete Action). s: `FirestoreService.delete_hospital`.
    """
    await service.delete_hospital(hospital_id)
    return {"message": "Hospital deleted successfully"}

@router.get("/", response_model=List[HospitalResponse])
async def list_hospitals(
    is_active: bool = True,
    island_group: Optional[str] = None,
    region: Optional[str] = None,
    city: Optional[str] = None,
    barangay: Optional[str] = None,
    service: FirestoreService = Depends(get_service)
):
    #  User Filter (GUI) -> API Query Params -> Firestore Query -> List of Hospitals.
    return await service.list_hospitals(is_active, island_group, region, city, barangay)

































